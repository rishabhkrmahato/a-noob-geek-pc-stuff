:: ========================================================================================
:: PowerShell Admin Launcher
:: Opens classic PowerShell with admin rights
:: EDIT THE APPEARANCE of LEGACY WINDOWS CONSOLE(s)
:: ========================================================================================

@echo off
:: Ensure Admin
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

:: Open a new classic PowerShell and pause it
start "Classic PowerShell" powershell.exe -NoExit -Command "& {Write-Host 'Right-click the title bar, go to Properties, and adjust settings as needed...'}"
exit
