@REM This Script performs a one-click complete registry backup, compresses it into a ZIP file on the desktop, and deletes the original .reg file. 

@echo off
:: Check for Admin Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Set Variables
set "Desktop=%USERPROFILE%\Desktop"
set "Timestamp=%date:/=-%_%time:~0,2%-%time:~3,2%"
@REM set "Timestamp=%date:/=-%_%time::=-%"
set "Timestamp=%Timestamp: =%"
set "Timestamp=%Timestamp:,=-%"
set "ZipFile=%Desktop%\RegistryBackup_%Timestamp%.zip"
set "RegFile=%Desktop%\WholeRegistryBackup.reg"

:: Export Complete Registry to Desktop
echo Backing up the registry to the DESKTOP ...
reg export HKLM "%RegFile%" /y

if errorlevel 1 (
    echo Failed to back up registry. Exiting.
    pause
    exit /b
)

:: Comment-out lines below if you don't have 7z installed.
:: Compress Backup File into 7z with Timestamp
set "SevenZipFile=%Desktop%\RegistryBackup_%Timestamp%.7z"
echo Compressing %RegFile% into %SevenZipFile%...
7z a -mx=9 "%SevenZipFile%" "%RegFile%"
:: replace 7z with full path if it's not on the SYSTEM PATH. 

if errorlevel 1 (
    echo Failed to compress backup with 7z. Exiting.
    pause
    exit /b
)

echo Registry backup successfully compressed and saved to %SevenZipFile%.

:: Uncomment lines below, if you want to use native windows ZIP (less compression) instead.
@REM :: Compress Backup File into ZIP with Timestamp
@REM echo Compressing %RegFile% into %ZipFile%...
@REM powershell -Command "Compress-Archive -Path '%RegFile%' -DestinationPath '%ZipFile%' -Force"
@REM echo Registry backup successfully compressed and saved to %ZipFile%.

if errorlevel 1 (
    echo Failed to compress backup. Exiting.
    pause
    exit /b
)

:: Delete the Original Registry Backup File
:: Comment section below, if you don't want to delete !
del "%RegFile%"
echo Original backup file deleted.

pause
