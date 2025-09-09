# 📦 Universal Package Manager Updater

A simple Windows batch script that automatically updates all your installed package managers and their packages in one go.

## ✨ Features

- **Auto-elevation**: Automatically requests admin privileges when needed
- **Smart detection**: Only runs updaters for installed package managers
- **Sequential execution**: Updates packages safely one at a time
- **Visual feedback**: Each update runs in its own window with progress display
- **Zero configuration**: Just run and forget

## 🛠️ Supported Package Managers

| Package Manager | Command |
|-----------------|---------|
| **Chocolatey** | `choco upgrade all -y` |
| **Scoop** | `scoop update` |
| **Python/pip** | Updates pip + auto-upgrades all packages |
| **npm** | `npm update -g` |
| **Ruby Gems** | Updates gem system + all gems |
| **winget** | `winget upgrade --all` |
| **Rust** | `rustup update && cargo update` |

## 🚀 Usage

1. **Download** the script to your preferred location
2. **Double-click** to run, or execute from command line:
   ```cmd
   update-all-packages.bat
   ```
3. **Allow elevation** when prompted (required for some package managers)
4. **Wait** for each updater to complete in its own window

## 📋 Requirements

- Windows OS
- Admin privileges (script will auto-elevate)
- At least one of the supported package managers installed

## ⚡ How It Works

The script:
1. Checks if running as administrator (elevates if not)
2. Tests each package manager's availability using `where` command
3. Launches updaters sequentially in separate windows
4. Skips any package managers not found in PATH
5. Waits for each update to complete before proceeding

## 🔧 Customization

To add new package managers, simply extend the arrays:

```batch
:: Add to names array
set names[7]=your-package-manager

:: Add corresponding command
set commands[7]=your-update-command

:: Update the loop range
for /L %%i in (0,1,7) do (
```

## 📝 Notes

- Some package managers may require internet connection
- Updates run with default/safe options (auto-accept, silent where possible)
- Each update window shows progress and waits for user confirmation
- Script uses delayed expansion for proper array handling

## 🤝 Contributing

Found a bug or want to add support for another package manager? Feel free to open an issue or submit a pull request!

---

*Part of [a-noob-geek-pc-stuff](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff) collection*