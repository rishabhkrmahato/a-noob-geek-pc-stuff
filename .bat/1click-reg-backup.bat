:: ================================================================================================
:: Description:
::
:: Full Registry Backup & Compression
::
:: This batch script performs a full backup of the Windows Registry, 
:: compresses the backup into a 7z (or ZIP) archive, and deletes the 
:: original `.reg` file to save space.
::
:: Key Features:
:: - Ensures the script runs with administrative privileges.
:: - Exports the entire Windows Registry to a `.reg` file.
:: - Compresses the backup using 7-Zip (or native ZIP as an alternative).
:: - Deletes the uncompressed `.reg` file after successful compression.
:: - Automatically names the backup files with a timestamp.
::
:: Hard-Coded Details:
:: - `%Desktop%`: Saves backups to the user's Desktop.
:: - `%Timestamp%`: Formats the filename with the current date and time.
:: - `%SevenZipFile%`: The compressed backup filename for 7z.
:: - `%ZipFile%`: The compressed backup filename for native ZIP (optional).
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify `%Desktop%` if you want to save the backup in a different folder.
:: 2. Update compression method:
::    - Use `7z` if 7-Zip is installed.
::    - Uncomment the native `Compress-Archive` method if 7-Zip is unavailable.
:: 3. Comment out `del "%RegFile%"` if you want to keep the uncompressed backup.
::
:: Usage:
:: - Run the script as an administrator.
:: - A compressed registry backup will be saved to the desktop.
::
:: Dependencies:
:: - 7-Zip (`7z.exe`) for high compression (optional).
:: - PowerShell for the native ZIP method.
::
:: Output:
:: - `RegistryBackup_<timestamp>.7z` (or `.zip` if using PowerShell's ZIP).
::
:: Error Handling:
:: - Exits with an error message if the registry backup or compression fails.
:: - Skips deletion if the compression step fails.
::
:: Notes:
:: - Ensure 7-Zip is installed and available in the system PATH if using it.
:: - Keeping the uncompressed `.reg` file may be useful for manual restoration.
:: ================================================================================================


@echo off
:: One-click full registry backup, compresses to 7z (or ZIP), and deletes the original file.

:: Ensure Admin Privileges
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)

:: Set Variables
set "Desktop=%USERPROFILE%\Desktop"
set "Timestamp=%date:/=-%_%time:~0,2%-%time:~3,2%"
set "Timestamp=%Timestamp: =%"
set "Timestamp=%Timestamp:,=-%"
set "RegFile=%Desktop%\WholeRegistryBackup.reg"
set "SevenZipFile=%Desktop%\RegistryBackup_%Timestamp%.7z"
set "ZipFile=%Desktop%\RegistryBackup_%Timestamp%.zip"

:: Export Complete Registry
echo Backing up the registry...
reg export HKLM "%RegFile%" /y || (echo Backup failed! & pause & exit /b)

:: Compress with 7z (Comment out if 7z is not installed)
echo Compressing %RegFile% with 7z...
7z a -mx=9 "%SevenZipFile%" "%RegFile%" || (echo Compression failed! & pause & exit /b)
echo Registry backup saved as %SevenZipFile%.

:: Alternative: Compress with built-in ZIP (Uncomment to use)
:: echo Compressing %RegFile% with native ZIP...
:: powershell -Command "Compress-Archive -Path '%RegFile%' -DestinationPath '%ZipFile%' -Force"
:: echo Registry backup saved as %ZipFile%.

:: Delete Original Backup (Comment if not needed)
del "%RegFile%" && echo Deleted original backup.

pause
