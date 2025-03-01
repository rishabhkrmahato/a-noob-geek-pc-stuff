:: ================================================================================================
:: Description:
:: Multi-Package Manager Updater
::
:: This batch script automates updating multiple package managers 
:: on Windows. It opens separate elevated terminal windows for each 
:: package manager and executes their respective update commands.
::
:: Key Features:
:: - Runs update commands for Chocolatey, Scoop, pip, npm, Ruby gems, and winget.
:: - Uses `Start-Process` in PowerShell to open each command in an elevated terminal.
:: - Allows additional package managers (e.g., Rust's `rustup` and `cargo`) to be added easily.
::
:: Hard-Coded Details:
:: - `%commands[n]%`: Predefined commands for updating different package managers.
:: - Currently includes:
::   - Chocolatey
::   - Scoop
::   - pip (Python)
::   - npm (Node.js)
::   - gem (Ruby)
::   - winget (Windows Package Manager)
::   - Rust (commented out but available for use).
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify the commands list (`set commands[n]=...`) to add/remove package managers.
:: 2. If using Rust (`rustup` and `cargo`), uncomment `commands[6]` and update the loop range.
:: 3. Adjust `Start-Process` arguments if needed for different execution behaviors.
::
:: Usage:
:: - Run this script to update all listed package managers.
:: - Each command runs in a separate elevated terminal window.
::
:: Dependencies:
:: - Windows with administrative privileges.
:: - Installed package managers (Chocolatey, Scoop, pip, npm, gem, winget, etc.).
::
:: Output:
:: - Each package manager runs in its own command prompt window.
:: - The user can review updates before closing each window.
::
:: Error Handling:
:: - If a package manager is missing, the respective command will fail silently.
:: - Users must manually review errors in opened terminals.
::
:: Notes:
:: - The script ensures updates are performed separately to prevent conflicts.
:: - Commands that require user agreements (`winget`) automatically accept them.
:: - For interactive updates, modify the commands to remove silent flags.
:: ================================================================================================


@echo off
setlocal EnableDelayedExpansion

:: Define commands
set commands[0]=choco upgrade all -y
set commands[1]=scoop update
set commands[2]=pip install --upgrade pip ^&^& pip install --upgrade pip-review ^&^& pip-review --auto
set commands[3]=npm update -g
set commands[4]=gem update --system ^&^& gem update ^&^& gem cleanup
set commands[5]=winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
@REM set commands[6]=rustup update ^&^& cargo update

:: Loop through each command and open an elevated terminal separately
@REM for /L %%i in (0,1,6) do (
for /L %%i in (0,1,5) do (
    powershell -Command "Start-Process cmd -ArgumentList '/k \"!commands[%%i]! ^& pause ^& exit\"' -Verb RunAs"
)

endlocal
