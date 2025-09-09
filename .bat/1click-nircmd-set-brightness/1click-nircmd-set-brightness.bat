@echo off
:: 1click NirCmd Brightness Setter

:: Check if NirCmd is available
where nircmd.exe >nul 2>&1 || (
    echo [Error] NirCmd not found. Place it in this folder or add to PATH.
    pause
    exit /b
)

:: Set brightness (change value as needed)
set "BRIGHTNESS=75"
nircmd.exe setbrightness %BRIGHTNESS%
echo Brightness set to %BRIGHTNESS%%.

pause
