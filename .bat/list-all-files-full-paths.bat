:: ================================================================================================
:: Description:
:: List & Save Files in a Folder
:: 
:: This batch script lists all files in a specified folder and 
:: optionally saves the output to a text file.
::
:: Key Features:
:: - Prompts the user to enter a folder path.
:: - Verifies if the folder exists before proceeding.
:: - Displays all files within the folder (including subfolders).
:: - Allows the user to save the file list to `file-list.txt`.
::
:: Usage:
:: - Run the script and enter the folder path when prompted.
:: - Optionally save the list to a text file by selecting "y".
::
:: Output:
:: - Displays the list of files in the console.
:: - Saves the file list to `file-list.txt` inside the folder (if chosen).
::
:: Error Handling:
:: - Exits if the specified folder does not exist.
::
:: Notes:
:: - The script processes subdirectories as well (`/r` flag).
:: - Modify `outputFile` if a different save location is preferred.
:: ================================================================================================


@echo off
setlocal

:: Get folder path from user
set /p "folder=Enter folder path: "

:: Verify folder existence
if not exist "%folder%" (echo Folder not found. & exit /b)

:: List files
echo Files in "%folder%":
for /r "%folder%" %%f in (*) do echo "%%f"

:: Save output?
echo.
set /p "saveOutput=Save output to a file (y/n)? "
if /i not "%saveOutput%"=="y" exit /b

:: Save file
set "outputFile=%folder%\file-list.txt"
(for /r "%folder%" %%f in (*) do echo "%%f") > "%outputFile%"
echo Saved to "%outputFile%"

pause
