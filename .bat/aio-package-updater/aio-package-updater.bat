@echo off
setlocal EnableDelayedExpansion

:: --- Elevate script if not admin ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- Names (for existence check) ---
set names[0]=choco
set names[1]=scoop
set names[2]=python
set names[3]=npm
set names[4]=gem
set names[5]=winget
set names[6]=rustup

:: --- Commands ---
set commands[0]=choco upgrade all -y
set commands[1]=scoop update
set commands[2]=python -m pip install --upgrade pip ^&^& python -m pip install --upgrade pip-review ^&^& pip-review --auto
set commands[3]=npm update -g
set commands[4]=gem update --system ^&^& gem update ^&^& gem cleanup
set commands[5]=winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
set commands[6]=rustup update ^&^& cargo update

:: --- Run sequentially in separate windows ---
for /L %%i in (0,1,6) do (
    where !names[%%i]! >nul 2>&1
    if !errorlevel! equ 0 (
        echo Launching updater for: !names[%%i]! ...
        start /wait cmd /c "echo ----- Updating: !names[%%i]! ----- & !commands[%%i]! & echo. & echo Press any key to continue... & pause"
    ) else (
        echo Skipping: !names[%%i]! (not found in PATH)
    )
)

endlocal
