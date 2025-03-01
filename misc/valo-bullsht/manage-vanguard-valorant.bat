:: ================================================================================================
:: Description:
::
:: VALORANT Vanguard Control Script
::
:: This batch script provides a menu-driven interface to manage Riot Games' 
:: Vanguard anti-cheat system. It allows users to check the status, stop, start, 
:: disable, and enable Vanguard services, as well as restart the PC if necessary.
::
:: Key Features:
:: - Ensures the script runs with administrative privileges.
:: - Provides an interactive menu for controlling Vanguard services.
:: - Allows stopping, starting, disabling, and enabling Vanguard (`vgc` and `vgk`).
:: - Supports system restart to apply changes if needed.
::
:: Usage:
:: - Run the script as an administrator.
:: - Select an option from the menu by entering the corresponding number.
::
:: Menu Options:
:: - [1] Check Status      → Displays the status of Vanguard services (`vgc`, `vgk`).
:: - [2] Stop Vanguard     → Stops Vanguard services and kills `vgtray.exe`.
:: - [3] Start Vanguard    → Starts Vanguard services.
:: - [4] Disable Vanguard  → Disables Vanguard services (prevents auto-start).
:: - [5] Enable Vanguard   → Enables Vanguard services (requires restart).
:: - [6] Restart PC        → Restarts the system in 11 seconds.
:: - [7] Exit              → Closes the script.
::
:: Dependencies:
:: - Windows with administrative privileges.
:: - `sc` and `net` commands for managing services.
:: - `taskkill` for terminating Vanguard-related processes.
::
:: Output:
:: - Displays real-time status updates in the terminal.
:: - Provides feedback for each action taken (e.g., "Vanguard stopped").
::
:: Error Handling:
:: - If the script is not run as an administrator, it auto-relaunches with elevated privileges.
:: - Silent handling of missing processes/services (will not stop the script).
::
:: Notes:
:: - Disabling Vanguard requires a restart for changes to fully take effect.
:: - Ensure no Riot Games processes are running before disabling Vanguard.
:: ================================================================================================

@echo off
title VALORANT CONTROL SCRIPT

:: Run as Admin
net session >nul 2>&1 || (powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs" & exit)

:menu
cls
echo VALORANT CONTROL SCRIPT
echo [1] Check Status  [2] Stop Vanguard  [3] Start Vanguard
echo [4] Disable Vanguard  [5] Enable Vanguard  [6] Restart PC  [7] Exit
set /p choice=Select an option: 

if %choice%==1 goto check_status
if %choice%==2 goto stop_services
if %choice%==3 goto start_services
if %choice%==4 goto disable_services
if %choice%==5 goto enable_services
if %choice%==6 goto restart_system
if %choice%==7 exit
goto menu

:check_status
cls
sc query vgc & sc query vgk
pause & goto menu

:stop_services
cls
net stop vgc & net stop vgk
taskkill /IM vgtray.exe /T /F
echo Vanguard stopped.
pause & goto menu

:start_services
cls
sc start vgc & sc start vgk
echo Vanguard started. Restart may be required.
pause & goto menu

:disable_services
cls
sc config vgc start= disabled & sc config vgk start= disabled
echo Vanguard disabled.
pause & goto menu

:enable_services
cls
sc config vgc start= demand & sc config vgk start= system
echo Vanguard enabled. Restart required.
pause & goto menu

:restart_system
cls
echo Restarting in 11 seconds...
shutdown /r /t 11
goto menu
