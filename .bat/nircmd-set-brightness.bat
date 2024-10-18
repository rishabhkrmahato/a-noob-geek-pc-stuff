@echo off

:: windows does not have native brightness control command line utility
:: get nircmd from nirsoft, its a multipurpose great cmd utility
:: add it to path or same system folder (faster way): unzip the contents and move nircmd.exe and nircmdc.exe to "C:\Windows\System32"

:main
cls
echo ==========================================
echo    Brightness Adjustment Program
echo ==========================================
:input
set /p brightness="Enter the brightness level (0-100): "

if %brightness% gtr 100 (
    echo Please enter a number between 0 and 100.
    goto input
)

if %brightness% lss 0 (
    echo Please enter a number between 0 and 100.
    goto input
)

nircmd.exe setbrightness %brightness%
echo Brightness set to %brightness%%.

:choice
echo.
echo Are you satisfied with the brightness level?
echo 1. Yes, exit the program.
echo 2. No, adjust the brightness again.
set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" goto exit
if "%choice%"=="2" goto main

echo Invalid choice, please enter 1 or 2.
goto choice

:exit
echo Exiting the program...
