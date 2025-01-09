:: ================================================================================================
:: Description:

@REM 1click Brightness Setter Using NirCmd

:: This script uses NirCmd to set the screen brightness to a 
:: specified level (CHANGE! in the code below). It checks if NirCmd is 
:: accessible in the PATH or the current directory and provides 
:: guidance if it's not found.
::
:: Key Features:
:: - Verifies the availability of NirCmd before proceeding.
:: - Adjusts screen brightness using NirCmd's `setbrightness` command.
:: - Displays clear error messages if NirCmd is not found.
::
:: Usage:
:: - Ensure NirCmd is downloaded and accessible in the PATH or 
::   placed in the script's directory.
:: - Run the script to set the brightness.
::
:: Dependencies:
:: - NirCmd utility (https://www.nirsoft.net/utils/nircmd.html)
::
:: Output:
:: - Sets screen brightness to the defined level and confirms success.
::
:: Error Handling:
:: - Exits with an error message if NirCmd is not found.
:: ================================================================================================

@echo off

:: Check if nircmd.exe is accessible
where nircmd.exe >nul 2>&1
if errorlevel 1 (
    echo NirCmd is not found in the PATH or the current directory.
    echo Please download NirCmd and ensure it is added to the PATH or placed in the current folder.
    pause
    exit /b
)

:: Set brightness
nircmd.exe setbrightness 75
echo Brightness set to 75 %.

@REM CHANGE! the value above, to your liking.
pause
