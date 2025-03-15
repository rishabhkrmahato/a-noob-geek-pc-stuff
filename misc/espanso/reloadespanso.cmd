:: ==========================================================================================================================
:: Restart Espanso (Admin Mode) 
:: - This script **restarts Espanso** (text expander tool) by:
::   1️⃣ Stopping the `espansod.exe` process (if running).
::   2️⃣ Waiting **3 seconds** for a safe restart.
::   3️⃣ Starting Espanso again via the **scheduled task** (`espanso-admin`).
:: - Requires **Administrator privileges** to manage the process.
:: ✅ **How to Use:**
:: - Run the script, and it will **automatically restart Espanso**.
:: - If Espanso is **not running**, the script **safely exits**.
:: 🚀 **Features:**
:: - reloadespanso (use directly from cli if added to PATH)
:: - **Automatic admin privilege request** for proper execution.
:: - **Checks if Espanso is running** before stopping it.
:: - **Waits 3 seconds** before restarting Espanso for safety.
:: - **Uses Windows Task Scheduler** (`schtasks`) to restart properly.
:: ⚠️ **Caution:**
:: - Ensure `espanso-admin` **exists** in Task Scheduler (`schtasks /query`).
:: - The script **only works on Windows**.
:: ==========================================================================================================================


@echo off
:: Check if running as admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Notify user
echo Restarting Espanso...
echo Stopping espansod.exe...

:: Check if espansod.exe is running before killing
tasklist | findstr /I "espansod.exe" >nul
if %errorLevel% equ 0 (
    taskkill /F /IM espansod.exe /T
) else (
    echo espansod.exe was not running.
)

:: Wait and notify
echo Waiting 3 seconds before restart...
timeout /t 3 /nobreak >nul

:: Restart task
echo Starting espanso-admin task...
schtasks /run /tn "espanso-admin"

:: Notify and exit after 3 seconds
echo Restart complete! Exiting in 3 seconds...
timeout /t 3 /nobreak >nul
exit /b
