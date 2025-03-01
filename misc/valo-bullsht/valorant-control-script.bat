:: ================================================================================================
:: Description:
:: Valorant Control Script
::
:: This batch script provides basic control over Riot Games' Valorant 
:: and its Vanguard anti-cheat system. It allows users to start and 
:: stop Valorant, including Riot Client and Vanguard services.
::
:: Key Features:
:: - Ensures administrative privileges for managing services and processes.
:: - Provides a menu-driven interface for easy control.
:: - Starts Vanguard (`vgc`), Riot Client, and Valorant.
:: - Stops Valorant, Riot Client, and Vanguard-related processes.
::
:: Usage:
:: - Run the script as an administrator.
:: - Select an option from the menu:
::   [1] Start Valorant    → Starts Vanguard and Riot Client.
::   [2] Stop Valorant     → Terminates all related processes.
::   [3] Exit              → Closes the script.
::
:: Hard-Coded Details:
:: - `"C:\Riot Games\Riot Client\RiotClientServices.exe"`: Path to Riot Client executable.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify the Riot Client path if Valorant is installed in a different location.
:: 2. Adjust the `timeout` values if needed for better timing control.
::
:: Dependencies:
:: - Windows with administrative privileges.
:: - `sc` command for managing Vanguard service.
:: - `taskkill` for terminating Riot processes.
::
:: Output:
:: - Displays status updates for starting and stopping Valorant services.
:: - Provides real-time feedback on process terminations.
::
:: Error Handling:
:: - If the script is not run as an administrator, it auto-relaunches with elevated privileges.
:: - Silent handling of missing processes/services (won't cause script failure).
::
:: Notes:
:: - Disabling `vgtray.exe` from startup is recommended for full control.
:: - Ensure Riot Client is not already running before starting Valorant.
:: ================================================================================================


@echo off

:: Run as Admin
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb runAs" & exit)

:menu
cls
echo ========= Valorant Control Script =========
echo [1] Start Valorant
echo [2] Stop Valorant
echo [3] Exit
set /p choice=Enter choice: 

if "%choice%"=="1" goto start_valorant
if "%choice%"=="2" goto stop_valorant
if "%choice%"=="3" exit
goto menu

:start_valorant
echo Starting Vanguard...
sc start vgc
timeout /t 5 >nul

echo Launching Riot Client...
start "" "C:\Riot Games\Riot Client\RiotClientServices.exe"
timeout /t 10 >nul
goto menu

:stop_valorant
echo Stopping Valorant and related processes...
taskkill /F /IM VALORANT.exe /IM RiotClientServices.exe /IM vgc.exe /IM vgtray.exe /T
echo Vanguard and Riot Client stopped.
goto menu
