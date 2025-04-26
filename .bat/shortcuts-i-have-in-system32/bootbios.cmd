:: ==========================================================================================
:: Boot to BIOS - Quick Restart into UEFI Firmware Settings
::
:: - 5-second countdown before reboot
:: - Auto-elevates to Admin if needed
:: - Uses: shutdown /r /fw /t 0 (UEFI only)
::
:: Notes:
:: - Requires Admin rights
:: - UEFI systems only (Not for Legacy BIOS)
:: - Save your work before running!
::
:: Usage:
:: - Run → Wait 5s → System reboots into BIOS
::
:: Update:
:: - Change countdown in (5,-1,1) if needed
:: - Remove /fw for non-UEFI systems
:: ==========================================================================================

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
