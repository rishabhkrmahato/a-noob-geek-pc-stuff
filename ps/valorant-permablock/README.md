# 🚫 Valorant Perma-Block

A comprehensive Windows script to permanently block Valorant and Riot Games applications from running or connecting to the internet.

## ⚡ Quick Start

1. **First**: Uninstall Valorant using [Revo Uninstaller](https://www.revouninstaller.com/) with deep scan
2. **Run**: Double-click `run-valorant-permablock.bat` as Administrator
3. **Done**: Valorant is now blocked system-wide

## 📋 What It Does

### 🌐 Network Blocking
- Blocks Riot domains in hosts file (`127.0.0.1` redirect)
- Creates Windows Firewall rules for all Riot executables
- Automatically retries hosts modification at startup if locked

### 🛑 Execution Blocking  
- Uses Image File Execution Options (IFEO) to prevent executables from running
- Blocks: `VALORANT.exe`, `RiotClientServices.exe`, `vgc.exe`, etc.

### 🧹 System Cleanup
- Removes Riot/Vanguard services (`vgc`, `vgk`)
- Deletes leftover folders in Program Files, ProgramData, LocalAppData
- Sets up automated cleanup tasks

### ⏰ Scheduled Tasks
- **Daily 3AM**: Remove downloaded Riot files from Downloads folder
- **At Login**: Clean up any Riot remnants and stop Vanguard services
- **At Startup**: Retry hosts file updates if previously locked

## 📁 Files

```
📄 valorant-permablock.ps1    # Main PowerShell script
📄 run-valorant-permablock.bat # Windows batch wrapper (run this)
```

## 🔧 Technical Details

- **Requires**: Windows 10/11, Administrator privileges
- **Creates**: `C:\ProgramData\RiotBlock\` for backups and maintenance scripts  
- **Backups**: Original hosts file before modification
- **Logging**: Timestamped output with INFO/OK/WARN levels

## 🔄 Reverting Changes

To undo the blocking:

1. **Hosts file**: Restore from backup in `C:\ProgramData\RiotBlock\backups\`
2. **Firewall**: Remove rules starting with "Block_"
3. **IFEO**: Delete registry keys under `HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\`
4. **Tasks**: Remove scheduled tasks starting with "RiotBlock-"

## ⚠️ Important Notes

- **Run as Administrator** - Required for system-level modifications
- **Revo Uninstaller first** - Clean removal prevents conflicts
- **Reversible** - All changes can be undone manually
- **Adds friction** - Makes reinstallation difficult but not impossible

## 🛠️ Troubleshooting

**Script won't run?**
- Ensure PowerShell execution policy allows scripts
- Right-click batch file → "Run as administrator"

**Hosts file locked?**
- Script will automatically retry at next startup
- Check Task Scheduler for "RiotBlock-FixHostsAtStartup"

**Still seeing Riot processes?**
- Reboot after running script
- Check Windows Defender exclusions

---

> **Disclaimer**: This script makes system-wide changes. Use responsibly and ensure you understand the modifications being made.