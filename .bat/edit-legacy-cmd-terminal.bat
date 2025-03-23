:: ========================================================================================
:: CMD Admin Launcher
:: Opens classic Command Prompt with admin rights
:: EDIT THE APPEARANCE of LEGACY WINDOWS CONSOLE(s)
:: ========================================================================================


@echo off
:: Ensure Admin
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

:: Open a new classic CMD and pause it
start "Classic CMD" cmd.exe /k echo Right-click the title bar, go to Properties, and adjust settings as needed...
exit
