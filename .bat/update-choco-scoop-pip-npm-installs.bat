@echo off

:: Check if the script is running as administrator, if not, prompt to restart as admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ============================================
    echo This script requires administrator privileges.
    echo Please restart as admin.
    echo ============================================
    pause
    exit /B
)

:: Script to update all packages for Chocolatey, Scoop, pip, and npm
echo.
echo ============================================
echo Updating Chocolatey packages...
echo ============================================
choco upgrade all --yes
echo.

echo ============================================
echo Updating Scoop packages...
echo ============================================
scoop update --force
echo.

echo ============================================
echo Updating pip packages...
echo ============================================
:: Old method for pip update (commented out)
:: pip list --outdated --format=freeze | findstr /v "pip==" | findstr /v "setuptools==" > outdated.txt
:: if exist outdated.txt (
::     for /f "delims==" %%i in (outdated.txt) do (
::         echo Updating %%i...
::         pip install --upgrade %%i --upgrade-strategy only-if-needed
::     )
::     del outdated.txt
:: ) else (
::     echo No outdated pip packages found.
:: )

:: New method for pip update using pip-review
pip install pip-review
pip-review --auto
echo.

echo ============================================
echo Updating npm packages...
echo ============================================
:: Old method for npm update (commented out)
:: npm outdated -g --depth=0 | findstr /v "Package" > npm_outdated.txt
:: if exist npm_outdated.txt (
::     for /f "tokens=1" %%j in (npm_outdated.txt) do (
::         echo Updating %%j...
::         npm update -g %%j
::     )
::     del npm_outdated.txt
:: ) else (
::     echo No outdated npm packages found.
:: )

:: New method for npm update
npm update -g
echo.

echo ============================================
echo All updates are complete!
echo ============================================
pause
exit /b
