# PowerShell Download Utility

A tiny, lightweight download utility for Windows, powered by the built-in `curl.exe`.

No dedicated download manager, GUI, installation or additional dependencies required.

## Features

- Direct downloads using `curl.exe`
- Automatic redirect handling
- Progress bar
- Automatic retry on failures
- Resume interrupted downloads
- Works from any directory through a PowerShell function

## Requirements

- Windows 10/11
- Windows PowerShell 5.1 or PowerShell 7+
- `curl.exe` available in PATH (included with modern Windows)

Check curl availability:

```powershell
curl.exe --version
```

## Installation

**1. Download `download.ps1`**

Clone this repository or download the script:

`ps/functions/download.ps1`

**2. Open your PowerShell profile**

```powershell
notepad $PROFILE
```

If the profile doesn't exist, create it first:

```powershell
New-Item -ItemType File -Path $PROFILE -Force
notepad $PROFILE
```

**3. Add the following line to your profile**

Replace the path with the actual location of your downloaded script:

```powershell
. "C:\Path\To\a-noob-geek-pc-stuff\ps\functions\download.ps1"
```

Save and close Notepad.

**4. Reload your profile**

```powershell
. $PROFILE
```

That's it! The `dl` function is now available whenever you open that PowerShell session.

## Usage

**Normal download**

```powershell
dl "https://example.com/file.exe"
```

**Resume an interrupted download**

```powershell
dl "https://example.com/file.zip" -Resume
```

The resume option uses HTTP range requests. The server must support them, and the partial file must be present in the current download directory.

## Verify Installation

```powershell
Get-Command dl
```

You should see `dl` listed as a Function.

## Notes

- Downloads are saved to the current working directory.
- The server-provided filename is used when available.
- Some websites require authentication, cookies or special headers. A copied download URL alone may not be sufficient.
- Temporary or signed download links may expire.
- This utility does not support segmented or multi-connection downloads.

## License

Part of [a-noob-geek-pc-stuff](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff).