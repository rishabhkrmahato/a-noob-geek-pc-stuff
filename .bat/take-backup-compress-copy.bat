:: ================================================================================================
:: Description:
:: Sonu Lenovo Backup Script
:: 
:: This script automates the process of backing up important user files,
:: compressing the backup with 7-Zip, and optionally copying it to a USB drive.
:: It also logs all operations to a log file.
::
:: Key Features:
:: - Creates a timestamped backup folder in `R:\`.
:: - Excludes hidden and system files to speed up the process.
:: - Uses `robocopy` for reliable file transfer with mirroring (`/MIR`).
:: - Compresses the backup folder into a `.7z` archive for space efficiency.
:: - Optionally copies the archive to a USB drive (`D:\`).
::
:: Hard-Coded Details:
:: - `R:\` is the main backup destination.
:: - `D:\` is set as the USB drive for storing the compressed backup.
:: - `"%USERPROFILE%\Pictures\Memories"` and `"%USERPROFILE%\Downloads\TORRENT DOWNLOADS"` are excluded.
:: - The backup is named `sonu-lenovo-backup-YYYY-MM-DD-HH-MM-SS.7z`.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify `backupFolder=R:\sonu-lenovo-backup-%timestamp%` to change the backup location.
:: 2. Adjust the `robocopy` exclusions to include or exclude specific folders.
:: 3. Change `"C:\Program Files\7-Zip\7z.exe"` if 7-Zip is installed elsewhere.
:: 4. Modify the USB copy destination (`D:\`) if using a different drive letter.
::
:: Usage:
:: - Run the script with administrative privileges for full functionality.
:: - All backups will be created in `R:\` with a timestamp.
:: - The `.7z` archive can be copied to a USB drive (`D:\`).
::
:: Dependencies:
:: - 7-Zip (`7z.exe`) for compression.
:: - `robocopy` (built into Windows) for fast and reliable file transfer.
::
:: Output:
:: - Backup folder: `R:\sonu-lenovo-backup-YYYY-MM-DD-HH-MM-SS\`
:: - Compressed archive: `R:\sonu-lenovo-backup-YYYY-MM-DD-HH-MM-SS.7z`
:: - Log file: `%USERPROFILE%\backup-script-verbosed.log`
::
:: Error Handling:
:: - Logs all backup operations and errors to `%logFile%`.
:: - Skips folders that don't exist or are inaccessible.
::
:: Notes:
:: - Ensure `R:\` has enough storage space before running.
:: - The script can be scheduled using Task Scheduler for automated backups.
:: ================================================================================================


@echo off
:: Enable logging
set "logFile=%USERPROFILE%\backup-script-verbosed.log"
setlocal enabledelayedexpansion
echo Enabled LOGGING...
echo.

:: Set date and time variables
for /f "tokens=2 delims==" %%i in ('"wmic os get localdatetime /value | findstr LocalDateTime"') do set "dt=%%i"
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%-%dt:~8,2%-%dt:~10,2%-%dt:~12,2%"

:: Set backup folder location
set "backupFolder=R:\sonu-lenovo-backup-%timestamp%"
mkdir "%backupFolder%" 2>nul
echo Backup folder created at R:\

:: Backup files
echo Backing up files... (excluding hidden & system files)
echo.

:: Backup Pictures (excluding "Memories")
robocopy "%USERPROFILE%\Pictures" "%backupFolder%\Pictures" /MIR /A-:SH /XD "%USERPROFILE%\Pictures\Memories" >> "%logFile%" 2>&1
echo ✔ Pictures backup completed.

:: Backup Documents
robocopy "%USERPROFILE%\Documents" "%backupFolder%\Documents" /MIR /A-:SH >> "%logFile%" 2>&1
echo ✔ Documents backup completed.

:: Backup Downloads (excluding "TORRENT DOWNLOADS")
robocopy "%USERPROFILE%\Downloads" "%backupFolder%\Downloads" /MIR /A-:SH /XD "%USERPROFILE%\Downloads\TORRENT DOWNLOADS" >> "%logFile%" 2>&1
echo ✔ Downloads backup completed.

echo ✅ Backup Complete! Proceeding to compression...
pause

:: Compress backup folder using 7-Zip
set "zipFile=R:\sonu-lenovo-backup-%timestamp%.7z"
echo Compressing backup...
"C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 "%zipFile%" "%backupFolder%" >> "%logFile%" 2>&1
echo ✔ Compression completed at R:\

pause 

:: Copy archive to USB (D:\)
echo Copying archive to USB (D:\)...
robocopy "R:\" "D:\" "%zipFile%" >> "%logFile%" 2>&1

:: Uncomment below to delete 7z file from R:\ after copying
@REM del "%zipFile%" 

echo ✅ Backup, Compression, and Copy complete!
echo Script LOGGED at %logFile%
echo.
pause

:: Display logged output
type "%logFile%"
echo.
pause
