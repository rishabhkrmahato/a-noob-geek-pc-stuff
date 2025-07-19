# Offline Explorer-like Folder Snapshot Generator (Final, Polished Version)

import os
from pathlib import Path
from datetime import datetime
import urllib.parse
import html
import webbrowser

ROOT_DIR = input("Enter the full path of the folder to snapshot: ").strip('"')
ROOT_PATH = Path(ROOT_DIR)
EXPORT_DIR = Path.cwd() / (ROOT_PATH.name + "_SnapshotHTML")
EXPORT_DIR.mkdir(exist_ok=True)

if not ROOT_PATH.exists() or not ROOT_PATH.is_dir():
    print("❌ The specified folder does not exist or is not a folder.")
    exit(1)

TIME_NOW = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
FILE_COUNT = 0
FOLDER_COUNT = 0

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Index of {path}</title>
<style>
body {{ font-family: Segoe UI, sans-serif; margin: 20px; background: #f9f9f9; color: #333; }}
table {{ border-collapse: collapse; width: 100%; background: #fff; box-shadow: 0 0 10px rgba(0,0,0,0.1); }}
th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
th {{ background-color: #0078D4; color: white; }}
tr:nth-child(even) {{ background-color: #f2f2f2; }}
a {{ text-decoration: none; color: #0078D4; }}
a:hover {{ text-decoration: underline; }}
p {{ margin-top: 10px; font-size: 14px; color: #555; }}
.folder::before {{ content: "📁 "; }}
.file::before {{ content: "📄 "; }}
</style>
</head>
<body>
<h2>Index of {path}</h2>
<p>Generated on {time_now}</p>
<table>
<tr><th>Name</th><th>Size (KB)</th><th>Last Modified</th></tr>
{rows}
</table>
<p><a href="../index.html">⬅️ Up one level</a></p>
</body>
</html>
"""

def generate_index_html(source_folder: Path, export_folder: Path):
    global FILE_COUNT, FOLDER_COUNT
    rows = []

    try:
        for item in sorted(source_folder.iterdir()):
            safe_name = html.escape(item.name)
            encoded_name = urllib.parse.quote(item.name)
            modified_time = datetime.fromtimestamp(item.stat().st_mtime).strftime('%Y-%m-%d %H:%M:%S')

            if item.is_dir():
                FOLDER_COUNT += 1
                row = f"<tr><td class='folder'><a href='{encoded_name}/index.html'>{safe_name}/</a></td><td>--</td><td>{modified_time}</td></tr>"
                rows.append(row)

            elif item.is_file():
                FILE_COUNT += 1
                size_kb = f"{item.stat().st_size / 1024:.2f}"
                row = f"<tr><td class='file'>{safe_name}</td><td>{size_kb}</td><td>{modified_time}</td></tr>"
                rows.append(row)

    except PermissionError:
        print(f"⚠️ Skipped {source_folder} due to permission error.")
        return

    relative_path = source_folder.relative_to(ROOT_PATH)
    export_current = export_folder / relative_path
    export_current.mkdir(parents=True, exist_ok=True)

    html_content = HTML_TEMPLATE.format(
        path=str(relative_path) if str(relative_path) else '/',
        time_now=TIME_NOW,
        rows='\n'.join(rows)
    )

    with open(export_current / "index.html", "w", encoding="utf-8") as f:
        f.write(html_content)

    print(f"✅ Generated index.html for: {source_folder}")

def main():
    for current_dir, dirs, files in os.walk(ROOT_PATH):
        current_path = Path(current_dir)
        generate_index_html(current_path, EXPORT_DIR)

    root_index = EXPORT_DIR / "index.html"
    if root_index.exists():
        webbrowser.open(root_index.as_uri())

    print(f"\n🎉 Snapshot complete! Total folders: {FOLDER_COUNT}, Total files: {FILE_COUNT}.")
    print(f"You can now open {root_index} in your browser to browse offline.")

if __name__ == "__main__":
    main()
