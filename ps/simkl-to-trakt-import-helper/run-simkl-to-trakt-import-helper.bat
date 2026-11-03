@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0simkl-to-trakt-import-helper.ps1"
echo.
pause
