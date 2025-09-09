# Extract From Links 🔗

A simple Windows batch script that downloads content from multiple URLs and merges them into a single text file.

## Features

- 📥 **Bulk Download** - Download content from multiple URLs at once
- 🔗 **Link Management** - Read URLs from a simple text file
- 📄 **Auto Merge** - Combine all downloaded content into one file
- 🚀 **Quick Access** - Automatically opens the merged file when done

## Usage

1. Create a `links.txt` file with your URLs (one per line):
   ```
   https://example.com/file1.txt
   https://api.example.com/data
   https://raw.githubusercontent.com/user/repo/main/file.txt
   ```

2. Run the script:
   ```cmd
   extract-from-links.txt.bat
   ```

3. The script will:
   - Download each URL to the `extracted/` folder
   - Merge all content into `combined.txt`
   - Open the merged file automatically

## Requirements

- Windows OS
- `curl` (included in Windows 10+ by default)

## File Structure

```
├── extract-from-links.txt.bat    # Main script
├── links.txt                     # Your URLs (create this)
├── extracted/                    # Downloaded files folder
└── combined.txt                  # Final merged output
```

## Example

```cmd
C:\> echo https://httpbin.org/uuid > links.txt
C:\> echo https://httpbin.org/ip >> links.txt
C:\> extract-from-links.txt.bat

[*] Downloading: https://httpbin.org/uuid
[*] Downloading: https://httpbin.org/ip
[DONE] Merged into "combined.txt"
```

## Notes

- Empty lines in `links.txt` are automatically skipped
- Downloaded files are named based on the URL path
- The merged file overwrites previous runs
- Script exits with error if `links.txt` is missing

---

*Part of my [automation scripts collection](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff)*