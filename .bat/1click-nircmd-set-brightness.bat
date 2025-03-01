:: ================================================================================================
:: Description:
:: Brightness Adjustment (Using NirCMD)
:: 
:: This script sets the screen brightness to a predefined level using NirCMD.
:: It first checks if NirCMD is available before applying the brightness setting.
::
:: Key Features:
:: - Verifies if `nircmd.exe` is installed and accessible.
:: - Sets screen brightness to a predefined value (default: 75%).
:: - Allows users to modify the brightness level easily.
::
:: Hard-Coded Details:
:: - Brightness level is set to `75` by default.
::
:: Steps to Update Hard-Coded Details:
:: 1. Change the brightness value (`nircmd.exe setbrightness 75`) to your preference.
:: 2. Ensure `nircmd.exe` is added to the system PATH or placed in the script directory.
::
:: Usage:
:: - Run the script to instantly adjust brightness to the specified level.
::
:: Dependencies:
:: - Requires `nircmd.exe` (Download from NirSoft).
::
:: Output:
:: - Displays confirmation when brightness is adjusted.
::
:: Error Handling:
:: - Exits with a message if NirCMD is not found.
::
:: Notes:
:: - Some systems may not support `nircmd.exe setbrightness`, depending on hardware and drivers.
:: ================================================================================================


@echo off

where nircmd.exe >nul 2>&1
if errorlevel 1 (
    echo NirCmd is not found in the PATH or the current directory.
    echo Please download NirCmd and ensure it is added to the PATH or placed in the current folder.
    pause
    exit /b
)

nircmd.exe setbrightness 75
echo Brightness set to 75 %.

@REM CHANGE! the value above, to your liking.
pause
