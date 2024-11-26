@echo off

:: Enable logging
set logFile=%USERPROFILE%\Documents\backup-script-verbosed.log
(

:: Set date and time variables
for /f "tokens=2 delims==" %%i in ('"wmic os get localdatetime /value | findstr LocalDateTime"') do set dt=%%i
set yyyy=%dt:~0,4%
set mm=%dt:~4,2%
set dd=%dt:~6,2%
set hh=%dt:~8,2%
set nn=%dt:~10,2%
set ss=%dt:~12,2%
set timestamp=%yyyy%-%mm%-%dd%-%hh%-%nn%-%ss%

:: Set backup folder location
set backupFolder=R:\sonu-lenovo-backup-%timestamp%
mkdir "%backupFolder%"

:: Backup files
echo.
echo backing up files ...
echo.
robocopy "%USERPROFILE%\Pictures" "%backupFolder%\Pictures" /MIR /XD "%USERPROFILE%\Pictures\Memories"
robocopy "%USERPROFILE%\Documents" "%backupFolder%\Documents" /MIR
robocopy "%USERPROFILE%\Downloads" "%backupFolder%\Downloads" /MIR /XD "%USERPROFILE%\Downloads\TORRENT DOWNLOADS"
@REM robocopy "%USERPROFILE%\Videos" "%backupFolder%\Videos" "jai shree ram.mp4"

:: Compress the backup folder using 7-Zip
:: Set zipfile location
set zipFile=D:\sonu-lenovo-backup-%timestamp%.7z
echo.
echo compressing backup ...
echo.
"C:\Program Files\7-Zip\7z.exe" a -t7z -mx=9 "%zipFile%" "%backupFolder%"

echo.
echo Backup and compression complete!
) > "%logFile%" 2>&1

pause
