@echo off
:: ====================================================
:: 1-Click Full Registry Backup & Compression
:: Prefers 7-Zip, falls back to native PowerShell ZIP
:: ====================================================

:: Require Admin Privileges
net session >nul 2>&1 || (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Variables
set "Desktop=%USERPROFILE%\Desktop"
for /f "tokens=1-4 delims=/- " %%a in ("%date%") do set "d=%%a-%%b-%%c"
for /f "tokens=1-2 delims=: " %%a in ("%time%") do set "t=%%a-%%b"
set "Timestamp=%d%_%t%"
set "RegFile=%Desktop%\WholeRegistryBackup.reg"
set "SevenZipFile=%Desktop%\RegistryBackup_%Timestamp%.7z"
set "ZipFile=%Desktop%\RegistryBackup_%Timestamp%.zip"

:: Backup Registry
echo [*] Backing up registry...
reg export HKLM "%RegFile%" /y || (
    echo [!] Backup failed.
    pause & exit /b
)

:: Try 7z compression
where 7z >nul 2>&1
if not errorlevel 1 (
    echo [*] Compressing with 7-Zip...
    7z a -mx=9 "%SevenZipFile%" "%RegFile%" >nul && (
        del "%RegFile%" && echo [*] Deleted original .reg file.
        echo [✓] Registry backup saved as: %SevenZipFile%
        pause & exit /b
    )
    echo [!] 7-Zip compression failed, trying fallback...
)

:: Fallback: PowerShell ZIP
echo [*] Compressing with native ZIP...
powershell -Command "Compress-Archive -Path '%RegFile%' -DestinationPath '%ZipFile%' -Force" || (
    echo [!] ZIP compression failed.
    pause & exit /b
)

del "%RegFile%" && echo [*] Deleted original .reg file.
echo [✓] Registry backup saved as: %ZipFile%
pause
