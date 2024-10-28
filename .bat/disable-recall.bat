@echo off
title Recall Feature Management Tool

:: Admin Check
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ============================================================
    echo     Please run this script as Administrator to continue.
    echo ============================================================
    echo.
    pause
    exit /b
)

:menu
cls
echo ============================================================
echo                    Recall Feature Management
echo ============================================================
echo.
echo     1. Get Recall Feature Status
echo     2. Disable Recall Feature
echo     3. Enable Recall Feature
echo     4. Exit
echo.
set /p "choice=Select an option (1-4): "

if "%choice%"=="1" goto GetStatus
if "%choice%"=="2" goto DisableRecall
if "%choice%"=="3" goto EnableRecall
if "%choice%"=="4" exit /b

:GetStatus
cls
echo.
echo ============================================================
echo                Getting Recall Feature Status
echo ============================================================
echo.
Dism /Online /Get-FeatureInfo /FeatureName:Recall
echo.
echo ============================================================
echo            Press any key to return to main menu
echo ============================================================
pause >nul
goto menu

:DisableRecall
cls
echo.
echo ============================================================
echo                  Disabling Recall Feature
echo ============================================================
echo.
Dism /Online /Disable-Feature /FeatureName:Recall
echo.
echo Recall feature has been disabled.
echo.
goto RestartPrompt

:EnableRecall
cls
echo.
echo ============================================================
echo                  Enabling Recall Feature
echo ============================================================
echo.
Dism /Online /Enable-Feature /FeatureName:Recall
echo.
echo Recall feature has been enabled.
echo.
goto RestartPrompt

:RestartPrompt
echo ============================================================
echo               Restart Required to Complete Action
echo ============================================================
echo Recall feature has been %choice%!
set /p "minutes=Enter minutes before restart (e.g., 1-60): "
shutdown /r /t %minutes% * 60
echo Restarting in %minutes% minutes. Save your work!
echo ============================================================
pause
goto menu
