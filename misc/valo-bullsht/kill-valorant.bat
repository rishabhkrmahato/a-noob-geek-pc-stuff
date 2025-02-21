:: ================================================================================================
:: 
:: Description:
::
:: Terminate Riot Games and Related Processe
::
:: This batch script forcefully terminates processes related to Riot Games, 
:: Valorant, Overwolf, and Valorant Tracker. It ensures that all related 
:: applications and their child processes are closed.
::
:: Key Features:
:: - Checks for administrative privileges and relaunches the script with elevated rights if needed.
:: - Forcefully terminates specified processes and their child processes.
:: - Provides timestamped logs for process termination actions.
::
:: Hard-Coded Details:
:: - `%processes%`: A predefined list of process names to be terminated.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify the `set "processes=..."` line to add or remove process names as needed.
:: 2. Ensure the process names match the ones shown in Task Manager (`tasklist` command can help verify).
::
:: Usage:
:: - Run the script as an administrator to ensure successful process termination.
:: - The script will attempt to close all listed processes and display timestamps for each action.
::
:: Dependencies:
:: - Windows with administrative privileges.
::
:: Output:
:: - Console output with timestamps indicating the termination status of each process.
::
:: Error Handling:
:: - Processes not running or already closed will be silently ignored.
:: - If administrative privileges are not granted, the script will relaunch with elevation.
::
:: Notes:
:: - Always ensure you save work in any open applications before running this script, 
::   as forceful termination can cause unsaved data loss.
:: - Modify the process list carefully to avoid terminating critical system processes.
:: ================================================================================================



@echo off
:: -------------------------------------------
:: Check for administrative privileges
:: If not running as admin, relaunch the script with elevated rights
:: -------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [%time%] Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /B
)

:: -------------------------------------------
:: Kill Riot Games, Valorant, Overwolf, and Valorant Tracker processes
:: -------------------------------------------
echo.
echo [%time%] Stopping RiotClient, Valorant, Overwolf, and Valorant Tracker processes...
echo.

:: List of processes to terminate
set "processes=RiotClientServices.exe RiotClientUx.exe RiotClientUxRender.exe VALORANT.exe VanguardTray.exe vgtray.exe vgc.exe Overwolf.exe 'Valorant Tracker.exe'"

:: Loop through each process and attempt termination
for %%p in (%processes%) do (
    echo [%time%] Terminating %%~p...
    taskkill /F /T /IM %%~p >nul 2>&1
)

echo.
echo [%time%] All targeted processes and their child processes have been terminated.
pause
