# Deprecated Batch Scripts

> **⚠️ Notice**: These scripts are deprecated and may not work reliably on modern Windows systems. Use at your own discretion.

A collection of older Windows batch scripts that may still have value for specific use cases, but are no longer actively maintained or recommended for general use.

## 📂 Scripts Overview

### 1. **disable-recall.bat**
**Windows Recall Feature Management Tool**

An interactive batch script to manage the Windows Recall feature through DISM commands.

**Features:**
- ✅ Check Recall feature status
- ❌ Disable Recall feature  
- ✅ Enable Recall feature
- 🔄 Automated restart scheduling

**Usage:**
```cmd
# Run as Administrator
disable-recall.bat
```

**Requirements:**
- Windows with DISM support
- Administrator privileges
- Restart required after changes

**Menu Options:**
- `1` → Get Recall Feature Status
- `2` → Disable Recall Feature  
- `3` → Enable Recall Feature
- `4` → Exit

---

## 🚨 Important Notes

- **Admin Rights Required**: All scripts in this folder require administrator privileges
- **Use with Caution**: These are deprecated scripts - test in a safe environment first
- **Backup Recommended**: Create system restore points before running system-modifying scripts
- **Windows Compatibility**: Scripts may not work on newer Windows versions

## 📋 Quick Setup

1. Clone or download the repository
2. Navigate to `\.bat\depreciated\`
3. Right-click script → **Run as administrator**
4. Follow on-screen prompts

## 🔗 Related

- **Main Repository**: [a-noob-geek-pc-stuff](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff)
- **Active Scripts**: Check parent directories for current/maintained scripts

---

*Last updated: September 2025*