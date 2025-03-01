:: ================================================================================================
:: Description:
:: Brightness Adjustment Tool (Using NirCMD)
:: 
:: This batch script allows users to adjust screen brightness using NirCMD.
:: It ensures NirCMD is installed before execution and validates user input 
:: to accept only numbers between 0 and 100.
::
:: Key Features:
:: - Checks if NirCMD is available before running.
:: - Prompts the user to enter a brightness level (0-100).
:: - Validates user input to prevent incorrect values.
:: - Adjusts the screen brightness using `nircmd.exe setbrightness`.
:: - Allows the user to adjust brightness again or exit.
::
:: Hard-Coded Details:
:: - Assumes `nircmd.exe` is installed in `C:\Windows\System32` or the script’s directory.
::
:: Steps to Update Hard-Coded Details:
:: 1. Ensure `nircmd.exe` is installed and accessible from the system PATH.
:: 2. Modify input validation rules if different constraints are needed.
::
:: Usage:
:: - Run the script and enter a brightness level (0-100).
:: - The script applies the brightness setting and provides an option to adjust again or exit.
::
:: Dependencies:
:: - NirCMD (`nircmd.exe`) must be installed and accessible.
::
:: Output:
:: - Displays confirmation when brightness is adjusted.
:: - Provides an option to re-adjust or exit after applying brightness.
::
:: Error Handling:
:: - Displays an error if NirCMD is not found.
:: - Ensures only valid numeric input is accepted (0-100 range).
::
:: Notes:
:: - This script modifies brightness settings, which may not work on all devices 
::   without proper driver support.
:: ================================================================================================


@echo off
:: Brightness Adjustment Script using NirCMD
:: Ensure nircmd.exe is placed in "C:\Windows\System32" or the script's directory

:: Check if NirCMD is available
where nircmd.exe >nul 2>&1 || (
    echo NirCMD not found! Please install it and add to system path.
    pause
    exit /b
)

:main
echo ==========================================
echo    Brightness Adjustment Program
echo ==========================================

:: Input validation loop
:input
set /p brightness="Enter the brightness level (0-100): "
:: Ensure input is a number
echo %brightness%| findstr /r "^[0-9][0-9]*$" >nul || (
    echo Invalid input! Please enter a number between 0 and 100.
    goto input
)
:: Ensure number is within range
if %brightness% gtr 100 (
    echo Please enter a number between 0 and 100.
    goto input
)
if %brightness% lss 0 (
    echo Please enter a number between 0 and 100.
    goto input
)

:: Apply brightness
nircmd.exe setbrightness %brightness%
echo Brightness set to %brightness%%.

:: Ask user if they want to adjust again
echo.
echo 1. Exit
echo 2. Adjust brightness again
set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" goto exit
if "%choice%"=="2" goto main

echo Invalid choice, please enter 1 or 2.
echo. && goto main

:exit
echo Exiting...
