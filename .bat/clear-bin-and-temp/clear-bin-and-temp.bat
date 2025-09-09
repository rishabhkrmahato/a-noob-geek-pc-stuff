@echo off
:: Minimal Temp + RecycleBin cleaner (single-file, portable)
:: Usage: double-click or run from a terminal. No user prompts.

setlocal EnableExtensions EnableDelayedExpansion

:: --- Variables ---
set "TEMPDIR=%TEMP%"

:: safety check
if not exist "%TEMPDIR%" (
  echo Temp folder not found: "%TEMPDIR%"
  endlocal & exit /b 1
)

echo Cleaning temporary files in: "%TEMPDIR%"

:: --- Delete files (skips files in use) ---
:: Using forfiles to delete files; it silently skips locked files.
forfiles /p "%TEMPDIR%" /s /m *.* /c "cmd /c del /f /q @path" >nul 2>&1

:: --- Remove subdirectories (try a few passes to remove nested folders) ---
for /l %%i in (1,1,3) do (
  for /f "delims=" %%D in ('dir "%TEMPDIR%" /ad /b 2^>nul') do (
    rd /s /q "%TEMPDIR%\%%D" >nul 2>&1
  )
)

:: --- Empty Recycle Bin silently via PowerShell ---
echo Emptying Recycle Bin...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1

echo Cleanup complete.
endlocal
exit /b 0
