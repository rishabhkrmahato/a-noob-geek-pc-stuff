@echo off
REM run-valorant-permablock.bat
REM Place this file in the same folder as valorant-permablock.ps1

REM Start an elevated PowerShell that runs the PS1 with ExecutionPolicy Bypass (process-only)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -NoExit -Command & \"%~dp0valorant-permablock.ps1\"' -Verb RunAs"

REM Note:
REM - This asks for UAC (Run as Administrator).
REM - -NoExit keeps the PowerShell window open after the script finishes so you can review output.
