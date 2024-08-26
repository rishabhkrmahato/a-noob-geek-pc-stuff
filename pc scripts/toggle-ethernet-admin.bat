:: toggle ethernet on or off without physically dis/re-connecting from the back of your pc every time.

@echo off

REM Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

REM Toggle Ethernet 2 interface status
netsh interface show interface "Ethernet 2" | findstr /C:"Connected" >nul
if %errorlevel%==0 (
    echo Disabling Ethernet 2...
    netsh interface set interface "Ethernet 2" admin=disable
    echo Ethernet 2 disabled.
) else (
    echo Enabling Ethernet 2...
    netsh interface set interface "Ethernet 2" admin=enable
    echo Ethernet 2 enabled.
)

pause
