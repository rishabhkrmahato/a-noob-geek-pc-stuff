:: ================================================================================================
:: Description:
:: Ethernet Toggle Script
:: 
:: This script toggles the Ethernet connection ON/OFF without physically
:: disconnecting the cable, allowing quick control of network access.
::
:: Key Features:
:: - Ensures administrative privileges before execution.
:: - Automatically detects the active Ethernet adapter.
:: - Stores the last toggled adapter in a file for future use.
:: - Uses `netsh` to disable or enable the network adapter.
::
:: Hard-Coded Details:
:: - `%toggle_file%`: Stores the last used Ethernet adapter in `last_ethernet_toggle.txt`.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify `%toggle_file%` if a different storage location is preferred.
:: 2. If multiple adapters exist, refine detection logic to select a specific one.
::
:: Usage:
:: - Run the script to toggle Ethernet ON/OFF.
:: - The script will detect the current state and switch it accordingly.
::
:: Dependencies:
:: - Requires administrative privileges (`netsh` commands need elevation).
::
:: Output:
:: - Displays the detected adapter and its toggled state.
::
:: Error Handling:
:: - If no active Ethernet adapter is found, the script exits safely.
:: - Stores the last used adapter for future toggling.
::
:: Notes:
:: - This script is useful for quickly disabling/enabling wired connections.
:: - If Wi-Fi is in use, this script does not affect it.
:: ================================================================================================


@echo off
:: Toggle Ethernet on/off without physically disconnecting the cable
setlocal enabledelayedexpansion

REM Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

REM File to store last toggled adapter
set toggle_file=%USERPROFILE%\last_ethernet_toggle.txt

REM Check if a last used adapter is stored
if exist "%toggle_file%" (
    set /p active_adapter=<"%toggle_file%"
    echo.
    echo Using previously toggled adapter: "!active_adapter!"
) else (
    echo.
    echo Finding active Ethernet adapter...
    
    for /f "tokens=1,* delims=:" %%A in ('ipconfig ^| findstr /I /C:"Ethernet adapter"') do (
        set adapter=%%A
        set adapter=!adapter:Ethernet adapter =!
        
        REM Check if adapter is connected
        netsh interface show interface "!adapter!" | findstr /C:"Connected" >nul 2>&1
        if !errorlevel! == 0 (
            echo.
            echo Found active adapter: "!adapter!"
            set active_adapter=!adapter!
            echo !adapter!>"%toggle_file%"
            goto :toggle
        )
    )

    echo.
    echo No active Ethernet adapter found.
    pause
    exit /b
)

:toggle
REM Toggle Ethernet ON/OFF
echo.
netsh interface show interface "!active_adapter!" | findstr /C:"Connected" >nul
if !errorlevel! == 0 (
    echo Disabling "!active_adapter!"...
    netsh interface set interface "!active_adapter!" admin=disable
    echo "!active_adapter!" disabled.
) else (
    echo Enabling "!active_adapter!"...
    netsh interface set interface "!active_adapter!" admin=enable
    echo "!active_adapter!" enabled.
)

pause
