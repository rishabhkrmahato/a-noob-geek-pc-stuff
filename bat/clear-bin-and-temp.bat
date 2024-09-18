:: remove files from temporary folder of windows, excluding ones in use, and clears recycle bin 

@echo off

:: Delete all files in %temp% directory
echo Deleting temporary files...
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*.*") do rd /s /q "%%p" >nul 2>&1

:: Clear the Recycle Bin
echo Emptying Recycle Bin...
powershell.exe -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo Cleanup complete!

pause

