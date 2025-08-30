@echo off
setlocal

:: Silent Symlink Maker
:: Always overwrites if symlink already exists
:: Author: Rishabh (Sonu)

if "%~1"=="" exit /b 1
set "target=%~1"
if not exist "%target%" exit /b 1

set "dir=%~dp1"
set "name=%~n1"
set "ext=%~x1"
set "link=%dir%%name% - Symlink%ext%"

:: Remove old file/folder if present
rmdir /s /q "%link%" 2>nul
del /f /q "%link%" 2>nul

:: Detect type and make symlink
if exist "%target%\" (
    mklink /D "%link%" "%target%" >nul
) else (
    mklink "%link%" "%target%" >nul
)
