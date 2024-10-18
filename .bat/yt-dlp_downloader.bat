@echo off

:: Checking if yt-dlp is installed by trying to run it
yt-dlp --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo yt-dlp is not installed or not found in PATH.
    echo.
    echo Please install yt-dlp to continue.
    echo You can install yt-dlp using Chocolatey for a simpler method:
    echo 1. Install Chocolatey if not already installed:
    echo    - Open Command Prompt as Administrator.
    echo    - Run the command: @powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "& { $(irm https://chocolatey.org/install.ps1 -UseBasicP) }"
    echo    - Restart Command Prompt to refresh environment variables.
    echo 2. Install yt-dlp using Chocolatey:
    echo    - Run the command: choco install yt-dlp
    echo.
    echo You can also download yt-dlp manually from: https://github.com/yt-dlp/yt-dlp/releases
    echo Steps to install manually:
    echo 1. Download the yt-dlp.exe file from the website.
    echo 2. Place yt-dlp.exe in a folder, e.g., C:\yt-dlp.
    echo 3. Add C:\yt-dlp to your system's PATH.
    echo 4. Then rerun this script after installation.
    pause
    exit /b
)

setlocal

:: Prompt for download location
set /p download_location="Enter the download location (e.g., C:\Users\YourName\Videos): "

:: Prompt for video URL
set /p video_url="Enter the video URL: "

:: Run yt-dlp with the provided inputs
yt-dlp -f bestvideo+bestaudio -o "%download_location%\%%(title)s.%%(ext)s" %video_url%

echo Download complete!
pause
