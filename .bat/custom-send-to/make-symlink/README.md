# Symlink Maker

A lightweight Windows batch script that creates symbolic links with a clean, predictable naming convention.
- TIP: use it directly from "send-to"

## ✨ Features

- **Silent operation** - No console output, perfect for automation
- **Smart detection** - Automatically handles both files and directories
- **Safe overwriting** - Removes existing symlinks before creating new ones
- **Clean naming** - Adds " - Symlink" suffix to distinguish from originals

## 🚀 Usage

```batch
symlink_maker.bat "path\to\your\file-or-folder"
```

### Examples

```batch
# Create symlink for a file
symlink_maker.bat "C:\Documents\important.txt"
# Creates: "C:\Documents\important - Symlink.txt"

# Create symlink for a directory
symlink_maker.bat "C:\Projects\MyApp"
# Creates: "C:\Projects\MyApp - Symlink"
```

## 📋 Requirements

- Windows with administrative privileges (required for mklink)
- Target file or directory must exist

## 🔧 How it works

1. Validates the target path exists
2. Removes any existing symlink with the same name
3. Detects if target is a file or directory
4. Creates appropriate symlink type (`mklink` for files, `mklink /D` for directories)
5. Returns exit code 1 if target doesn't exist, 0 on success

## 💡 Use Cases

- Quick access to frequently used files/folders
- Creating shortcuts without cluttering context menus
- Automation scripts that need temporary file references
- Development workflows with multiple project locations

---

**Author:** Rishabh (Sonu)  
**License:** Open source - feel free to modify and share!