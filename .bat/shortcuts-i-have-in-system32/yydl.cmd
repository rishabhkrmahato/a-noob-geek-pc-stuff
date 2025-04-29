@echo off

:: Check if URL is provided
if "%~1"=="" (
    echo Usage: yydl.cmd [YouTube URL or other supported link]
    exit /b 1
)

:: Set output directory
set "OUTDIR=%USERPROFILE%\Videos"

:: Run yt-dlp
yt-dlp -f "bv*+ba/best" --merge-output-format mp4 -o "%OUTDIR%\%%(title)s.%%(ext)s" %1
