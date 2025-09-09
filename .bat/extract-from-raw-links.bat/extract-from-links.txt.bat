@echo off
setlocal enabledelayedexpansion

rem ================================
rem  Extract & Merge Links Downloader
rem ================================

set "output=extracted"
set "links=links.txt"
set "merged=combined.txt"

rem Check if links.txt exists
if not exist "%links%" (
    echo [ERROR] "%links%" not found.
    exit /b 1
)

rem Create output folder
if not exist "%output%" mkdir "%output%"

rem Download files
for /f "usebackq tokens=* delims=" %%L in ("%links%") do (
    if not "%%L"=="" (
        echo [*] Downloading: %%L
        curl -s "%%L" -o "%output%\%%~nL.txt"
    )
)

rem Merge text files
> "%merged%" (
    for %%F in ("%output%\*.txt") do type "%%F"
)

echo [DONE] Merged into "%merged%"

rem Open merged file if it exists
if exist "%merged%" start "" "%merged%"
