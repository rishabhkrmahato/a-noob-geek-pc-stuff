@echo off

:: Check if the script is running as administrator, if not, relaunch as admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /B
)

:: Script to update all packages for Chocolatey, Scoop, and pip
echo Updating Chocolatey packages...
choco upgrade all --yes

echo.
echo Updating Scoop packages...
scoop update --force

echo.
echo Updating pip packages...
:: Use the pip freeze command correctly and filter out unwanted packages
pip list --outdated --format=freeze | findstr /v "pip==" | findstr /v "setuptools==" > outdated.txt
if exist outdated.txt (
    for /f "delims==" %%i in (outdated.txt) do (
        echo Updating %%i...
        pip install --upgrade %%i --upgrade-strategy only-if-needed
    )
    del outdated.txt
) else (
    echo No outdated pip packages found.
)

echo.
echo All updates are complete!
pause
exit /b
