:: ================================================================================================
:: Description:
:: Hide Files in Plain Sight - Swap Filename & Extension 
:: 
:: This script renames files by swapping their filename and extension, 
:: effectively obscuring their original type while keeping them accessible.
::
:: Key Features:
:: - Allows users to drag and drop files or manually enter paths.
:: - Swaps the filename and extension to make file types less obvious.
:: - Preserves functionality for certain file types when swapped back.
::
:: Hard-Coded Details:
:: - Uses `ren` to rename files based on extracted filename (`~nF`) and extension (`~xF`).
:: - Removes the dot from the extension before swapping.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify file selection logic if bulk processing from a folder is needed.
:: 2. Adjust script behavior to handle specific file types differently if required.
::
:: Usage:
:: - Run the script and enter or drag & drop file paths.
:: - The script renames each file by swapping its filename and extension.
:: - Example: `document.txt` → `txt.document`
::
:: Dependencies:
:: - Standard Windows Command Prompt (`cmd`).
::
:: Output:
:: - Displays renamed file paths for reference.
::
:: Error Handling:
:: - Skips files that don't have an extension.
:: - Ensures the renaming process handles special characters properly.
::
:: Notes:
:: - Some extensions, when reversed, may still function (e.g., `.jpg` → `jpg.filename`).
:: - Files can be restored by running the script again or manually renaming them.
:: ================================================================================================


@echo off
:: changed the idea to swapping filename and extension, cause reversing some extensions like txt will result in txt only making it accessible :)

setlocal enabledelayedexpansion

title Hide Files in Plain Sight - Swap Filename ^& Extension 

echo.
echo Drag and drop files into this window (or enter paths manually).
echo Multiple files should be separated by spaces.
set /p "files=Enter file path(s): "

for %%F in (%files%) do (
    set "fullpath=%%~fF"
    set "name=%%~nF"
    set "ext=%%~xF"

    if not "!ext!"=="" (
        set "ext=!ext:~1!"  & rem Remove the dot from the extension
        ren "!fullpath!" "!ext!.!name!"
        echo Renamed: !fullpath! → !ext!.!name!"
    )
)

echo.
echo Process completed.
pause
