@echo off
:: Restart the batch script as Administrator if not already started with elevated privileges

:: Check if the script is running with elevated privileges
openfiles >nul 2>&1
if '%ERRORLEVEL%' NEQ '0' (
    echo This script requires administrative privileges.
    echo.
    echo Restarting with administrative privileges...
    echo.
    :: Restart the script as Administrator
    powershell -Command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

:: This script converts an MKV file to MP4 using FFmpeg.

:: Checking if FFmpeg is installed by trying to run it
ffmpeg -version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo FFmpeg is not installed or not found in PATH.
    echo.
    echo Please install FFmpeg to continue.
    echo You can install FFmpeg using Chocolatey for a simpler method:
    echo 1. Install Chocolatey if not already installed:
    echo    - Open Command Prompt as Administrator.
    echo    - Run the command: @powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "& { $(irm https://chocolatey.org/install.ps1 -UseBasicP) }" 
    echo    - Restart Command Prompt to refresh environment variables.
    echo 2. Install FFmpeg using Chocolatey:
    echo    - Run the command: choco install ffmpeg
    echo.
    echo You can also download FFmpeg manually from: https://ffmpeg.org/download.html
    echo Steps to install manually:
    echo 1. Download the FFmpeg zip file from the website.
    echo 2. Extract the contents to a folder, e.g., C:\FFmpeg.
    echo 3. Add C:\FFmpeg\bin to your system's PATH.
    echo 4. Then rerun this script after installation.
    pause
    exit /b
)

:: Ask user for input MKV file path
set /p inputPath="Enter the full path of the MKV file: "

:: Determine output file path (same directory, same name but with .mp4 extension)
set "outputPath=%~dpn1.mp4"

:: Run FFmpeg to convert the file
ffmpeg -i "%inputPath%" -c copy "%outputPath%"

echo.
echo Conversion complete! The file has been saved as %outputPath%.
pause
exit /b
