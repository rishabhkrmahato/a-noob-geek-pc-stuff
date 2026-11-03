# Magnet and .torrent association registry generator

This Windows helper creates a `.reg` file for an application selected through a standard file picker. It registers the selected `.exe` for `magnet:` links and `.torrent` files under the current Windows user.

## Why this tool exists

Some applications do not register themselves as handlers for magnet links or `.torrent` files. This can happen with portable apps, or when an application's normal association setup fails. This tool was made for that situation, including the author's case with qBittorrent Portable.

The program you select must accept a magnet URI and a `.torrent` path as command-line arguments. For a portable app, select its launcher if that launcher is the program that should receive those links and files.

## Use

1. Keep `Run-Generator.cmd` and `Create-MagnetTorrentReg.ps1` in the same folder.
2. Double-click `Run-Generator.cmd`. The terminal explains the steps, then a file picker opens.
3. Select the application's `.exe`.
4. Choose where to save the generated `.reg` file.
5. Double-click the generated `.reg` file and confirm Registry Editor.
6. Open **Settings → Apps → Default apps** and choose the registered application for `magnet` and `.torrent` if Windows has not already selected it.

The generated `.reg` is UTF-16LE with a byte-order mark for Registry Editor compatibility. The generator does not import it or change the registry. Importing it writes only to `HKEY_CURRENT_USER`.

## Notes

- A `.reg` file cannot display a file picker or set Windows' protected default-app choice by itself. The PowerShell generator provides the picker; Windows may still require selecting the app in Default apps.
- The selected program needs to support receiving a magnet URI or `.torrent` path as a quoted command-line argument.
- The registration writes the `magnet` protocol handler and `.torrent` class mapping for the current user. It can replace existing per-user values for those same associations. Back up any existing association you may want to restore before importing.
- `Run-Generator.cmd` starts Windows PowerShell with a process-only execution-policy bypass so the downloaded helper can open. It does not change the machine's execution policy.