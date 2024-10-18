@echo off
:: Check if the script is running as administrator, if not, relaunch as admin
:: Batch code to request administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /B
)

:: Now that we are running as admin, proceed with the task killing
echo Stopping RiotClient, Valorant, Overwolf, and Valorant Tracker processes...
echo.
echo.

:: Taskkill for Riot and Valorant related processes along with their child processes
taskkill /F /T /IM RiotClientServices.exe
taskkill /F /T /IM RiotClientUx.exe
taskkill /F /T /IM RiotClientUxRender.exe
taskkill /F /T /IM VALORANT.exe
taskkill /F /T /IM VanguardTray.exe
taskkill /F /T /IM vgtray.exe
taskkill /F /T /IM vgc.exe

:: Taskkill for Overwolf and Valorant Tracker processes along with their child processes
taskkill /F /T /IM "Valorant Tracker.exe"
taskkill /F /T /IM Overwolf.exe

echo.
echo.
echo All processes terminated, including child processes.
pause
