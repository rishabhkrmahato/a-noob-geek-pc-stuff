# Create File

> A simple Windows batch script to generate dummy files of any specified size

## ✨ Features

- **Interactive prompts** - Enter filename and size through user-friendly prompts
- **Flexible sizing** - Specify file size in MB for easy calculation
- **Input validation** - Ensures file size is a valid number
- **Full path display** - Shows complete file location after creation
- **Error handling** - Clear feedback for failed operations

## 🚀 Usage

1. **Run the script**
   ```cmd
   create-file.bat
   ```

2. **Enter filename** (include extension)
   ```
   Enter the file name (with extension): test.txt
   ```

3. **Specify size in MB**
   ```
   Enter the file size in MB: 100
   ```

The file will be created in the current directory with the exact size specified.

## 📋 Requirements

- **Windows OS** with `fsutil` command available
- **Administrator privileges** may be required on some systems
- **PowerShell** or **Command Prompt**

## 💡 Use Cases

- **Testing** - Create files for storage/transfer testing
- **Development** - Generate mock files for application testing  
- **Disk management** - Allocate specific amounts of disk space
- **Performance testing** - Create files of known sizes for benchmarks

## ⚠️ Important Notes

- Files are created **empty** but occupy the full specified disk space
- Uses `fsutil file createnew` which requires appropriate permissions
- File size conversion: `1 MB = 1,048,576 bytes`

## 🔧 Technical Details

The script uses Windows' built-in `fsutil` command to efficiently allocate disk space without writing actual data, making it much faster than other file creation methods.

---

**Part of [a-noob-geek-pc-stuff](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff) collection**