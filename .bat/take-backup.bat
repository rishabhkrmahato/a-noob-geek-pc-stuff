@echo off

:: Enable logging
set logFile=%USERPROFILE%\backup-script-verbosed.log
setlocal enabledelayedexpansion
echo Enabled LOGGING ...
echo.

:: Set date and time variables
for /f "tokens=2 delims==" %%i in ('"wmic os get localdatetime /value | findstr LocalDateTime"') do set dt=%%i
set yyyy=%dt:~0,4%
set mm=%dt:~4,2%
set dd=%dt:~6,2%
set hh=%dt:~8,2%
set nn=%dt:~10,2%
set ss=%dt:~12,2%
set timestamp=%yyyy%-%mm%-%dd%-%hh%-%nn%-%ss%
echo.
echo Set date and time variables done.

:: Set backup folder location
set backupFolder=R:\sonu-lenovo-backup-%timestamp%
mkdir "%backupFolder%"
echo.
echo Made backup folder at R:\

:: Backup files
echo.
echo Backing up files ... 
echo (avoiding: hidden files, system files, and excluded dirs)
:: my music, my pictures, my videos lnk files will create issues here, make sure you delete them or run this as admin ! (else this script will be stuck in 30 secs retyring loop ...)
echo.

:: Backup Pictures (excluding hidden and system files)
robocopy "%USERPROFILE%\Pictures" "%backupFolder%\Pictures" /MIR /A-:SH /XD "%USERPROFILE%\Pictures\Memories" >> "%logFile%" 2>&1
echo.
echo Backup of Pictures completed.

:: Backup Documents (excluding hidden and system files)
robocopy "%USERPROFILE%\Documents" "%backupFolder%\Documents" /MIR /A-:SH >> "%logFile%" 2>&1
echo.
echo Backup of Documents completed.

:: Backup Downloads (excluding hidden and system files)
robocopy "%USERPROFILE%\Downloads" "%backupFolder%\Downloads" /MIR /A-:SH /XD "%USERPROFILE%\Downloads\TORRENT DOWNLOADS" >> "%logFile%" 2>&1
echo.
echo Backup of Downloads completed.

@REM :: Compress the backup folder using 7-Zip
@REM :: Set zipfile location
@REM set zipFile=D:\sonu-lenovo-backup-%timestamp%.7z
@REM echo.
@REM echo Compressing Backup ...
@REM "C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 "%zipFile%" "%backupFolder%" >> "%logFile%" 2>&1
@REM echo.
@REM echo Compression completed and stored at D:\

:: Compress the backup folder using 7-Zip
:: Set zipfile location on R drive first
set zipFile=R:\sonu-lenovo-backup-%timestamp%.7z
echo.
echo Compressing Backup ...
echo.
"C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 "%zipFile%" "%backupFolder%" >> "%logFile%" 2>&1
echo Compression completed at R:\

:: Move the archive to D:\ 
echo Copying to USB ...
robocopy "%R%" "%D%" "%zipFile%" >> "%logFile%" 2>&1

@REM del "%zipFile%"  :: Delete the 7z file from the R drive after moving
:: uncomment line above to move it, currently only copies. 

echo.
echo Copied archive to Ventoy USB (D:\)

:: Final message
echo.
echo Backup and compression complete!
echo Script LOGGED at %USERPROFILE%\backup-script-verbosed.log 
pause
echo.

:: Display output in terminal
echo.
echo Displaying LOGGED output in terminal ...
echo.
type "%logFile%"
echo.

pause
