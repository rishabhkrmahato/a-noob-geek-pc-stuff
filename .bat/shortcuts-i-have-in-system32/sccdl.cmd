@echo off
setlocal

:: --------------------------------------------------
:: SoundCloud Downloader (sccdl.cmd)
:: Author : Rishabh (Sonu)
:: Usage  : sccdl <soundcloud_url>
:: --------------------------------------------------

:: Check if yt-dlp is installed
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo [ERROR] yt-dlp not found. Please install yt-dlp first.
    exit /b 1
)

:: Check if URL argument is provided
if "%~1"=="" (
    echo [USAGE] sccdl ^<soundcloud_url^>
    exit /b 1
)

set "URL=%~1"

echo [INFO] Downloading from: %URL%
yt-dlp -f bestaudio --embed-thumbnail --add-metadata "%URL%"
if errorlevel 1 (
    echo [ERROR] Download failed. Please check the URL or your connection.
    exit /b 1
)

:: Find the last downloaded file (newest in current folder)
set "LASTFILE="
for /f "delims=" %%F in ('dir /b /a:-d /o:-d') do (
    set "LASTFILE=%%F"
    goto :found
)

:found
if defined LASTFILE (
    echo [SUCCESS] Saved to: "%CD%\%LASTFILE%"
) else (
    echo [WARNING] Download complete, but could not detect saved file.
)

endlocal
exit /b 0
