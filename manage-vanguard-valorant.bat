@echo off

title VALORANT CONTROL SCRIPT

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script needs to be run as administrator.
    echo Restarting with elevated privileges...
    :: Restart script as admin
    powershell -Command "Start-Process cmd -ArgumentList '/c, %~s0' -Verb RunAs"
    exit /b
)
:: The rest of your batch script here
echo Running with administrator privileges...
echo.

:menu
cls
echo =========================================
echo VALORANT CONTROL SCRIPT - Manage Vanguard
echo =========================================
echo.
echo This program helps you manage Valorant's Vanguard anti-cheat system.
echo Purpose: 
echo To stop or disable Vanguard services to avoid them running in the background when you're not gaming.
echo.
echo Services Managed:
echo - vgc: Vanguard Client handles the anti-cheat communication.
echo - vgk: Vanguard Kernel Driver operates at the system level to prevent cheats.
echo - vgtray.exe: Vanguard Tray Icon (just an indicator showing Vanguard is running).
echo.
echo Terms:
echo - STOP: Temporarily stops the services until the next reboot or manual start.
echo - DISABLE: Permanently prevents the service from starting automatically.
echo - ENABLE: Allows the service to start again (auto or manual).
echo.
echo NOTE: 
echo After stopping/disabling Vanguard, you may still need to restart your PC before playing Valorant again.
echo.
echo ?:
echo Valorant requires a PC restart because its anti-cheat system, Vanguard, uses a kernel-level driver (vgk) that operates at the core of your system.
echo Kernel drivers cannot be started or stopped like regular services, so a reboot is necessary for changes to fully take effect.
echo The restart ensures system integrity, cleans out any residual processes, and properly reloads the security measures that protect against cheats.
echo This deep integration with Windows means a restart is required to safely load or unload the anti-cheat without leaving vulnerabilities.
echo.
echo ===================================================
echo.

echo [1] Check Current STATUS of Vanguard services
echo [2] STOP Vanguard services (vgc, vgk, vgtray)
echo [3] START Vanguard services (vgc, vgk)
echo [4] DISABLE Vanguard services (vgc, vgk)
echo [5] ENABLE Vanguard services (vgc, vgk)
echo [6] RESTART Your System
echo [7] Exit
echo.

set /p choice=Choose an option: 

if %choice%==1 goto check_status
if %choice%==2 goto stop_services
if %choice%==3 goto start_services
if %choice%==4 goto disable_services
if %choice%==5 goto enable_services
if %choice%==6 goto restart_system
if %choice%==7 exit

:check_status
cls
echo ===================================
echo CHECKING CURRENT STATUS OF VANGUARD
echo ===================================
sc query vgc
echo ---------------------------------------------------
sc query vgk
echo ---------------------------------------------------
echo.
echo ===================================================
echo Services checked: vgc (client), vgk (kernel)
pause
goto menu

:stop_services
cls
echo ==========================
echo STOPPING VANGUARD SERVICES
echo ==========================
net stop vgc
echo.
echo vgc service stopped.
net stop vgk
echo.
echo vgk service stopped.
echo.
taskkill /IM vgtray.exe /T /F
echo.
echo vgtray.exe and its child processes have been killed.
echo.
echo ===================================================
echo Stopped Vanguard services, you can continue your normal work.
::echo NOTE: You may still need to restart your PC before playing Valorant again.
pause
goto menu

:start_services
cls
echo ==========================
echo STARTING VANGUARD SERVICES
echo ==========================
sc start vgc
echo.
echo vgc service started.
sc start vgk
echo.
echo vgk service started.
echo.
echo ===================================================
echo NOTE: You may need to restart your PC before playing Valorant again.
pause
goto menu

:disable_services
cls
echo ===========================
echo DISABLING VANGUARD SERVICES
echo ===========================
sc config vgc start= disabled
echo.
echo vgc service disabled.
sc config vgk start= disabled
echo.
echo vgk service disabled.
echo.
echo ===================================================
echo Stopped auto-start of Vanguard services.
pause
goto menu

:enable_services
cls
echo ==========================
echo ENABLING VANGUARD SERVICES
echo ==========================
sc config vgc start= demand
echo.
echo vgc service enabled (manual start).
sc config vgk start= system
echo.
echo vgk service enabled (system start).
echo.
echo ===================================================
echo Vanguard services enabled. Restart needed.
pause
goto menu

:restart_system
cls
echo ======================
echo RESTARTING YOUR SYSTEM
echo ======================
echo.
echo System will restart in 11 seconds. Save your work!
shutdown /r /t 11
goto menu
