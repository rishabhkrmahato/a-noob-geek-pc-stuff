:: first disable `vgtray.exe` in Task Manager's startup.
:: run this to have control & stop Valorant (Tencent) from spying when you're not playing.
:: create shortcut, get an ico file, replace the startmenu valorant shortcut with this one.

@echo off

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ===========================================
    echo Requesting administrative privileges...
    echo ===========================================
    :: Re-run the script as admin
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

:menu
echo.
echo ========= Valorant Control Script =========
echo 1. Start Valorant
echo 2. Stop Valorant
echo 3. Exit
echo ===========================================
set /p choice=Enter your choice (1/2/3): 

if "%choice%"=="1" goto start_valorant
if "%choice%"=="2" goto stop_valorant
if "%choice%"=="3" exit
goto menu

:start_valorant
echo Starting Vanguard...
sc start vgc
timeout /t 5 >nul

echo Starting Riot Client...
start "" "C:\Riot Games\Riot Client\RiotClientServices.exe"
timeout /t 10 >nul

:: not needed just start valorant from riotclient only. (cause not everyone uses always signed in for valorant)
REM echo Starting Valorant... 
REM start "" "C:\Riot Games\VALORANT\live\VALORANT.exe"
goto back_to_menu

:stop_valorant
echo Stopping Valorant and related processes...
taskkill /F /IM VALORANT.exe /T
taskkill /F /IM RiotClientServices.exe /T
taskkill /F /IM vgc.exe /T
taskkill /F /IM vgtray.exe /T
echo Vanguard and Riot Client have been stopped.
goto back_to_menu

:back_to_menu
echo ===========================================
echo Press 4 to go back to the main menu.
echo Press any other key to exit.
echo ===========================================
set /p choice=Enter your choice: 
if "%choice%"=="4" goto menu
exit

:end
echo Done. Press any key to exit...
pause >nul
