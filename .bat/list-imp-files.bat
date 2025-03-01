:: ================================================================================================
:: Description:
:: List Important Files
:: 
:: This batch script scans common user directories (Downloads, Documents, 
:: Pictures, Music, and Videos) and lists all files, saving the output to 
:: a text file on the desktop.
::
:: Key Features:
:: - Automatically scans predefined user folders.
:: - Saves the file list to `ImportantFiles.txt` on the desktop.
:: - Removes the previous output file before creating a new one.
:: - Notifies the user to check the Recycle Bin for important files.
::
:: Hard-Coded Details:
:: - `%dirs%`: List of directories to scan (`Downloads`, `Documents`, etc.).
:: - `%output_file%`: File path where the results are saved.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify `%dirs%` to include additional folders if needed.
:: 2. Change `%output_file%` if you prefer a different save location.
::
:: Usage:
:: - Run the script to generate a list of files in common directories.
:: - The results will be saved to `ImportantFiles.txt` on the desktop.
::
:: Dependencies:
:: - Standard Windows environment variables (`%USERPROFILE%`).
::
:: Output:
:: - A text file listing all files found in specified directories.
::
:: Error Handling:
:: - Ensures the script does not fail if a directory is missing.
:: - Removes the old output file before creating a new one.
::
:: Notes:
:: - Modify the script to include additional checks, such as scanning 
::   external drives or network locations.
:: ================================================================================================


@echo off
setlocal

:: Define output file path
set "output_file=%USERPROFILE%\Desktop\ImportantFiles.txt"

:: Remove existing output file
if exist "%output_file%" del "%output_file%"

:: Define directories to check
set "dirs=Downloads Documents Pictures Music Videos"

:: List files in each directory
(
    for %%d in (%dirs%) do (
        set "dir_path=%USERPROFILE%\%%d"
        if exist "!dir_path!" (
            echo Files in !dir_path!:
            dir "!dir_path!" /b /s
            echo.
        )
    )
    echo Check for important files in the Recycle Bin.
) > "%output_file%"

endlocal
