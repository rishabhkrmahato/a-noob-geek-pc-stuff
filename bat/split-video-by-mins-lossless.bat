@echo off

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

setlocal enabledelayedexpansion

:: Prompt for the input file path
set /p input_file="Enter the path of the input file (e.g., C:\path\to\xyz.xyz): "

:: Prompt for the number of minutes
set /p segment_time="Enter the number of minutes for segment time (eg. 22): "

:: Prompt for the output directory path
set /p output_folder="Enter the full path for the output folder (shift+right-click>copy-as-path): "

:: Extract the base name and extension from the input file
for %%A in ("%input_file%") do (
    set "base_name=%%~nA"
    set "ext=%%~xA"
)

:: Run the FFmpeg command with the provided inputs
ffmpeg -i "%input_file%" -c copy -map 0 -segment_time %segment_time%*60 -f segment -reset_timestamps 1 -start_number 1 "%output_folder%\%base_name%%%03d%ext%"

:: Specify job done and output file names
echo.
echo Job done! The output files are located in: %output_folder%
for /l %%i in (1,1,999) do (
    set "output_file=%output_folder%\%base_name%%%03d%ext%"
    if exist "!output_file!" (
        echo Output file: "!output_file!"
    ) else (
        goto end
    )
)
:end
pause
