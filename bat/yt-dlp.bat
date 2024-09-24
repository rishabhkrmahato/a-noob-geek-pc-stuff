@echo off

REM ----------------------------------------
REM Instructions to install yt-dlp and set it up:
REM 1. Download yt-dlp.exe from:
REM    https://github.com/yt-dlp/yt-dlp/releases/latest
REM 2. After downloading, copy yt-dlp.exe to:
REM    C:\Windows\System32\
REM    (This allows yt-dlp to be used globally from any directory)
REM ----------------------------------------

REM Ask for the YouTube video link
set /p videolink="Enter the YouTube video link: "

REM Download the best video and audio, and save in the Videos folder
yt-dlp -f bestvideo+bestaudio -o "C:\Users\mahat\Videos\%(title)s.%(ext)s" %videolink%

REM Pause the script to keep the window open after download
pause
