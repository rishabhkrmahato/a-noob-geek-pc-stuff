# 🧹 Clear Bin & Temp

A minimal, portable Windows batch script for cleaning temporary files and emptying the recycle bin.

## ✨ Features

- **Silent operation** - No user prompts or confirmation dialogs
- **Portable** - Single `.bat` file, no installation required
- **Safe** - Skips files currently in use by other processes
- **Fast** - Efficiently removes temp files and subdirectories
- **Clean** - Empties recycle bin completely

## 🚀 Usage

### Quick Start
Simply **double-click** `clear-bin-and-temp.bat` to run.

### Command Line
```cmd
clear-bin-and-temp.bat
```

### Automation
Add to Windows Task Scheduler or include in your maintenance scripts.

## 📂 What it cleans

- **Temporary files** in `%TEMP%` directory
- **Temporary subdirectories** (up to 3 levels deep)
- **Recycle Bin** contents (all drives)

## ⚡ Technical Details

- Uses `forfiles` for efficient file deletion
- Leverages PowerShell's `Clear-RecycleBin` for recycle bin cleanup
- Handles locked/in-use files gracefully
- Multiple passes for nested directory removal
- Zero exit code on success

## 🛡️ Safety

The script includes safety checks and will:
- Verify temp directory exists before proceeding
- Skip files that are currently in use
- Suppress error messages for smoother operation
- Exit gracefully if temp directory is not found

## 📋 Requirements

- Windows 7/8/10/11
- PowerShell (for recycle bin cleanup)
- Standard user permissions (admin not required)

---

*Part of [a-noob-geek-pc-stuff](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff) collection*