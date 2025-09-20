:: ================================================================================================
:: Description:
:: Recall Feature Management Tool
::
:: This batch script provides an interactive menu to manage the Windows Recall feature.
:: It allows users to check the status, enable, or disable the feature using `Dism`.
::
:: Key Features:
:: - Ensures administrative privileges before execution.
:: - Provides an easy-to-use menu for Recall feature management.
:: - Uses `Dism` to get, enable, or disable the Recall feature.
:: - Prompts for a restart after enabling or disabling the feature.
::
:: Usage:
:: - Run the script as an administrator.
:: - Select an option from the menu:
::   [1] Get Recall Feature Status → Displays whether Recall is enabled.
::   [2] Disable Recall Feature    → Disables the Recall feature.
::   [3] Enable Recall Feature     → Enables the Recall feature.
::   [4] Exit                      → Closes the script.
::
:: Dependencies:
:: - Windows with `Dism` (Deployment Image Servicing and Management) available.
::
:: Output:
:: - Console output showing Recall feature status and any changes made.
::
:: Error Handling:
:: - If the script is not run as an administrator, it will exit with a message.
:: - If `Dism` commands fail, Windows will display relevant error messages.
::
:: Notes:
:: - Restart is required after enabling or disabling Recall.
:: - The user is prompted to set a custom restart delay after changes.
:: ================================================================================================


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

@REM :: minified form below
@REM @echo off
@REM openfiles >nul 2>&1 || (echo Run as Administrator. & pause & exit /b)

@REM :menu
@REM cls
@REM echo 1. Get Status  2. Disable  3. Enable  4. Exit
@REM set /p "c=Choice: "
@REM if "%c%"=="1" (Dism /Online /Get-Features | findstr /i "Recall" & pause & goto menu)
@REM if "%c%"=="2" (Dism /Online /Disable-Feature /FeatureName:Recall /NoRestart & echo Disabled. & goto restart)
@REM if "%c%"=="3" (Dism /Online /Enable-Feature /FeatureName:Recall /NoRestart & echo Enabled. & goto restart)
@REM if "%c%"=="4" exit /b
@REM goto menu

@REM :restart
@REM set /p "m=Restart in minutes (1-60): "
@REM echo %m% | findstr /r "^[1-9][0-9]*$" >nul || (echo Invalid input. & pause & goto restart)
@REM shutdown /r /t %m%0
@REM echo Restarting in %m% min. Save work!
@REM pause
