@echo off
setlocal enabledelayedexpansion

:: Get file name from the user
set /p filename="Enter the file name (with extension): "

:: Get file size in MB from the user
set /p filesizeMB="Enter the file size in MB: "

:: Convert MB to bytes (1MB = 1048576 bytes)
set /a filesize=%filesizeMB%*1048576

:: Create the file using fsutil
fsutil file createnew "%filename%" %filesize%

:: Check if the file was created successfully
if exist "%filename%" (
    echo File "%filename%" has been created.
    echo Full path: %~dp0%filename%
) else (
    echo Failed to create the file. Check your inputs.
)

pause
