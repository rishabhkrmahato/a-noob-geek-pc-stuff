:: ================================================================================================
:: Description:
:: Boot to BIOS
:: 
:: This script automates the process of restarting a Windows system 
:: directly into BIOS (UEFI Firmware Settings).
::
:: Key Features:
:: - Provides a 5-second countdown before initiating the restart.
:: - Checks for administrative privileges and elevates if needed.
:: - Uses `shutdown /r /fw /t 0` to reboot into BIOS automatically.
:: - Runs in a silent, minimal window for a seamless experience.
::
:: Hard-Coded Details:
:: - Countdown timer is set to 5 seconds (`for /l %%i in (5,-1,1)`).
:: - Uses `shutdown /r /fw /t 0` to restart into firmware settings.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify the countdown timer value if needed.
:: 2. If using a non-UEFI system, remove `/fw` (firmware restart flag).
::
:: Usage:
:: - Run the script normally; it will request admin rights if needed.
:: - Wait for the countdown to complete, and the system will reboot into BIOS.
::
:: Dependencies:
:: - Requires administrative privileges for system reboot.
:: - Compatible only with UEFI-based systems (not legacy BIOS).
::
:: Output:
:: - Displays a countdown before restarting into BIOS.
:: - Informs the user whether admin privileges were obtained.
::
:: Error Handling:
:: - Automatically elevates the script if not run as Administrator.
:: - Exits safely if elevation fails.
::
:: Notes:
:: - Useful for quickly accessing BIOS without manual key presses.
:: - Ensure all work is saved before running, as it forces a restart.
:: ================================================================================================


@echo off
title Boot to BIOS
setlocal EnableDelayedExpansion

:: 5-second countdown timer (unskippable)
for /l %%i in (5,-1,1) do (
    cls
    echo [INFO] Restarting into BIOS in %%i seconds...
    timeout /t 1 /nobreak >nul
)

:: Check for Admin Privileges
net session >nul 2>&1 || (
    echo [ACTION] Elevating to Administrator ...
    powershell -Command "Start-Process powershell -ArgumentList '-Command shutdown /r /fw /t 0' -Verb RunAs -WindowStyle Hidden"
    exit
)

:: If already Admin, proceed with restart
echo [INFO] Running as Administrator.
echo [INFO] Restarting to BIOS now ...
timeout /t 1 /nobreak >nul
shutdown /r /fw /t 0
exit
