@echo off

:: Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrative privileges. Restarting as administrator...
    :: Re-run the script with elevated privileges
    PowerShell -Command "Start-Process -Verb RunAs '%~f0'"
    exit /b
)

setlocal enabledelayedexpansion

:: Get current date and time for timestamp
for /f "tokens=1-3 delims= " %%a in ('date /t') do set TODAY=%%a
for /f "tokens=1-2 delims=:" %%b in ('time /t') do set TIME=%%b:%%c

:: Remove unwanted characters from date and time
set "TIMESTAMP=%TODAY%_%TIME%"
set "TIMESTAMP=%TIMESTAMP:/=-%"        :: Replace / with -
set "TIMESTAMP=%TIMESTAMP: =_%"
set "TIMESTAMP=%TIMESTAMP::=-%"         :: Replace : with -
set "TIMESTAMP=%TIMESTAMP:%=-%"          :: (Not needed in time format)
set "TIMESTAMP=%TIMESTAMP:.=-%"          :: (Not needed in time format)

:: Define maximum length for the restore point name
set MAX_LENGTH=50

:: Define invalid characters
set "INVALID_CHARS=\/:*?\"<>|"

echo.
:InputRestorePointName
:: Prompt for the restore point name
set /p RP_NAME="Enter the name for the restore point (max %MAX_LENGTH% characters, no special characters %INVALID_CHARS%): "

:: Check the length of the input
if "!RP_NAME!"=="" (
    echo You must enter a name.
    goto InputRestorePointName
)

:: Check if the name is too long
if "!RP_NAME:~%MAX_LENGTH%!" neq "" (
    echo The name is too long! Maximum allowed length is %MAX_LENGTH% characters.
    goto InputRestorePointName
)

:: Check for invalid characters
for %%C in (%INVALID_CHARS%) do (
    echo !RP_NAME! | findstr /C:%%C >nul
    if !errorlevel! == 0 (
        echo The name contains invalid characters: %%C
        goto InputRestorePointName
    )
)

:: Create the full restore point name with timestamp
set "FULL_RP_NAME=!RP_NAME!_!TIMESTAMP!"

echo.
:: Create the restore point
PowerShell.exe -Command "Checkpoint-Computer -Description '!FULL_RP_NAME!' -RestorePointType 'MODIFY'"

:: Check if the restore point was created successfully
if %errorlevel% neq 0 (
    echo Failed to create the restore point.
    exit /b 1
)

echo.
echo.
:: Display the details of the created restore point
PowerShell.exe -Command "Get-ComputerRestorePoint | Where-Object {$_.Description -eq '!FULL_RP_NAME!'} | Select-Object -Property SequenceNo, Description, CreationTime"

echo Restore point created successfully with name: !FULL_RP_NAME!
pause
