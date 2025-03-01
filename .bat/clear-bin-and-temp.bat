:: ================================================================================================
:: Description:
:: Windows Temporary Files & Recycle Bin Cleaner
::
:: This batch script removes all temporary files from the `%temp%` directory 
:: and empties the Recycle Bin. It ensures that only deletable files are removed, 
:: skipping files currently in use.
::
:: Key Features:
:: - Deletes all files in the `%temp%` folder.
:: - Removes subdirectories inside `%temp%` (skipping those in use).
:: - Clears the Windows Recycle Bin using PowerShell.
:: - Runs silently without user confirmation.
::
:: Usage:
:: - Run the script to free up space by removing unnecessary files.
:: - No user input is required; the script executes automatically.
::
:: Dependencies:
:: - Windows PowerShell (for clearing the Recycle Bin).
::
:: Output:
:: - Console messages confirming deletion of temp files and recycle bin cleanup.
::
:: Error Handling:
:: - Files in use are skipped automatically.
:: - PowerShell handles errors silently when clearing the Recycle Bin.
::
:: Notes:
:: - Ensure you have saved any work before running the script, as deleted 
::   files cannot be recovered from the Recycle Bin.
:: - Running as an administrator is not required but may help remove 
::   additional temporary files.
:: ================================================================================================


@echo off
:: remove files from temporary folder of windows, excluding ones in use, and clears recycle bin 

:: Delete all files in %temp% directory
echo Deleting temporary files...
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*.*") do rd /s /q "%%p" >nul 2>&1

:: Clear the Recycle Bin
echo Emptying Recycle Bin...
powershell.exe -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo Cleanup complete!
