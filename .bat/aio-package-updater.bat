@echo off
:: ===================================================================
:: Script to update all packages for chocolatey, scoop, pip, npm, and winget
:: Author: rishabhkrm
:: ===================================================================

:: Check if the script is running as administrator, if not, prompt to restart as admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ============================================================
    echo This script requires administrator privileges.
    echo Please restart it as admin.
    echo ============================================================
    pause
    exit /B
)

:: Intro Section
echo.
echo ============================================================
echo Welcome to the All-in-One Package Updater Script!
echo This script will update:
echo   1. Chocolatey packages
echo   2. Scoop packages
echo   3. pip Python packages
echo   4. npm Node.js packages
echo   5. winget (Windows Package Manager) packages
echo ============================================================
echo.

:: Updating Chocolatey packages
echo ============================================
echo Updating Chocolatey packages...
echo ============================================
choco upgrade all --yes
echo.

:: Updating Scoop packages
echo ============================================
echo Updating Scoop packages...
echo ============================================
scoop update --force
echo.

:: Updating pip packages
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

pip install pip-review
pip-review --auto
echo.

:: Updating npm packages
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

npm update -g
echo.

:: Updating winget packages
echo ============================================
echo Retrieving list of outdated winget packages...
echo ============================================
winget upgrade
echo.
echo NOTE: The listed applications will be force-closed for updates.
echo You have 7 seconds to pause this process if needed.
echo Press "Ctrl + C" to stop the script.
timeout /t 7 >nul
echo.

echo ============================================
echo Updating winget packages...
echo ============================================
winget upgrade --all --silent --force
echo ============================================
echo winget updates completed!
echo ============================================

@REM :: Updating winget packages -complex-logic
@REM echo ============================================
@REM echo Updating winget packages...
@REM echo ============================================
@REM :: List all outdated packages
@REM echo Retrieving list of outdated winget packages...
@REM set "outdated_programs=winget_outdated_list.txt"
@REM winget upgrade > "%outdated_programs%"

@REM :: Parse the output to get package names
@REM echo.
@REM echo The following programs will be updated:
@REM echo ------------------------------------------------------------
@REM findstr "Available" "%outdated_programs%" | findstr /v "No packages" > outdated_cleaned.txt
@REM for /f "tokens=1 delims= " %%i in (outdated_cleaned.txt) do echo - %%i
@REM echo ------------------------------------------------------------
@REM echo NOTE: The listed applications will be force-closed for updates.
@REM echo You have 5 seconds to pause this process if needed.
@REM timeout /t 5 >nul
@REM echo.

@REM :: Perform updates with force-close enabled
@REM for /f "tokens=1 delims= " %%i in (outdated_cleaned.txt) do (
@REM     echo Force updating %%i...
@REM     winget upgrade --id %%i --silent --force
@REM )
@REM :: Clean up temporary files
@REM del "%outdated_programs%" outdated_cleaned.txt
@REM echo ============================================
@REM echo winget updates completed!
@REM echo ============================================
echo.

:: Completion message
echo ============================================================
echo All updates are complete!
echo ============================================================
pause
exit /b
