:: ==============================================================================
:: Batch Downloader & Merger
::
:: - Downloads files from URLs in 'links.txt' using curl
:: - Saves them in the 'extracted' folder
:: - Merges all .txt files into 'combined.txt'
::
:: Requirements: curl (preinstalled in Windows 10+)
:: ==============================================================================

@echo off
setlocal enabledelayedexpansion
set "output_folder=extracted"

:: Check if links.txt exists
if not exist "links.txt" (
    echo ERROR: 'links.txt' not found.
    pause
    exit /b
)

:: Create output folder if missing
if not exist "%output_folder%" mkdir "%output_folder%"

:: Download each URL
for /f "usebackq tokens=* delims=" %%L in ("links.txt") do (
    if not "%%L"=="" (
        echo Downloading: %%L
        curl -s "%%L" -o "%output_folder%\%%~nL.txt"
    )
)

echo.
echo Downloads completed. Files saved in: "%output_folder%"
echo Merging all .txt files into 'combined.txt'...

copy /b "%output_folder%\*.txt" "combined.txt" >nul

echo Merge complete: combined.txt
pause
