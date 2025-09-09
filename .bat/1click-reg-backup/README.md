# 🔧 1-Click Registry Backup

A simple Windows batch script that creates a complete registry backup with automatic compression.

## ✨ Features

- **One-click operation** - Just run and go
- **Full registry backup** - Exports entire HKLM registry
- **Smart compression** - Uses 7-Zip (if available) or falls back to native ZIP
- **Auto-timestamped** - Files include date and time for easy organization
- **Admin handling** - Automatically requests elevation if needed
- **Desktop output** - Saves compressed backup to your desktop

## 🚀 Usage

1. **Download** `1click-reg-backup.bat`
2. **Right-click** → Run as Administrator (or just double-click - it will self-elevate)
3. **Wait** for the backup and compression to complete
4. **Find** your timestamped backup on the desktop

## 📁 Output

The script creates a compressed file on your desktop:
- `RegistryBackup_YYYY-MM-DD_HH-MM.7z` (if 7-Zip is installed)
- `RegistryBackup_YYYY-MM-DD_HH-MM.zip` (fallback)

## 📋 Requirements

- Windows OS
- Administrator privileges
- Optional: 7-Zip for better compression

## ⚡ Quick Install

```batch
# Clone and use
git clone https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff.git
cd a-noob-geek-pc-stuff
# Run 1click-reg-backup.bat
```

---
*Part of my [Windows automation scripts collection](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff)*