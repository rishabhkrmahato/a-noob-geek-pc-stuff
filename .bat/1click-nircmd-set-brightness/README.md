# 1Click Brightness Setter 💡

A simple Windows batch script for quick brightness adjustment using NirCmd.

## Features

- 🖱️ **One Click** - Set brightness instantly
- ⚡ **Fast** - No GUI delays or navigation
- 🔧 **Customizable** - Easy to modify brightness level
- ✅ **Smart Check** - Verifies NirCmd availability

## Setup

1. **Download NirCmd** from [NirSoft](https://www.nirsoft.net/utils/nircmd.html)
2. **Place** `nircmd.exe` in the same folder as this script, OR add it to your system PATH
3. **Customize** brightness level by editing the `BRIGHTNESS` value in the script (0-100)

## Usage

Simply double-click the `.bat` file to set your screen brightness to the configured level.

```cmd
Brightness set to 75%.
```

## Configuration

Edit the script to change the default brightness:

```batch
set "BRIGHTNESS=50"    :: For 50% brightness
set "BRIGHTNESS=100"   :: For maximum brightness  
set "BRIGHTNESS=25"    :: For low brightness
```

## Requirements

- Windows OS
- [NirCmd](https://www.nirsoft.net/utils/nircmd.html) utility

## File Structure

```
├── brightness-setter.bat    # This script
└── nircmd.exe              # NirCmd utility (required)
```

## Use Cases

- **Gaming** - Quickly dim screen for dark games
- **Night Mode** - Reduce eye strain in low light
- **Battery Saving** - Lower brightness to extend laptop battery
- **Presentations** - Adjust brightness for different environments

---

*Part of my [automation scripts collection](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff)*