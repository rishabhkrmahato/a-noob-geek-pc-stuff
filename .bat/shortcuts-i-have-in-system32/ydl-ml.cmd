@echo off

:: Check if the user provided an argument
if "%~1"=="" (
    echo Usage: ydl-ml.bat [file_with_links.txt]
    echo Description: Fetches links from the specified text file and downloads each using ydl.
    exit /b 1
)

:: Call PowerShell script
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ydl-ml.ps1" -InputFile "%~1"
