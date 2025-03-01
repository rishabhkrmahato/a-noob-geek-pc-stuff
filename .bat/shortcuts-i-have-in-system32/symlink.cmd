:: make sure to call in ADMIN terminal when required.

@echo off
setlocal

:: Ask user for the source file path
set /p source="Enter source file path: "
set "source=%source:"=%"  &:: Remove surrounding quotes if present

:: Check if the file exists
if not exist "%source%" (
    echo File does not exist!
    pause
    exit /b
)

:: Get the current directory (where script was executed)
set "targetDir=%CD%"

:: Extract filename from the source path
for %%F in ("%source%") do set "filename=%%~nxF"

:: Create the symlink in the current directory
mklink "%targetDir%\%filename%" "%source%" >nul 2>&1

:: Notify user
if %errorlevel%==0 (
    echo Symlink created successfully: "%filename%"
) else (
    echo Failed to create symlink! Ensure you have administrative privileges.
)
