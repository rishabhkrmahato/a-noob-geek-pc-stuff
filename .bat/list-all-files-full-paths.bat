@echo off
setlocal enabledelayedexpansion

:: Ask user for folder path (paste copied path here)
set /p folder="Enter the folder path: "

:: Check if the folder exists
if not exist "%folder%" (
    echo Folder does not exist.
    exit /b
)

:: List all files in the folder with full paths
echo Files in "%folder%":
for /r "%folder%" %%f in (*) do (
    echo "%%f"
)

echo.

:: Ask if the user wants to save the output to a file
set /p saveOutput="Do you want to save the list to a file (y/n)? "

if /i "%saveOutput%"=="y" (
    :: Set the output file path
    set outputFile=%folder%\all-files-with-full-paths-listed.txt

    :: Redirect the output to the file
    (
        for /r "%folder%" %%f in (*) do (
            echo "%%f"
        )
    ) > "%outputFile%"

    echo Output saved to "%outputFile%"
) else (
    echo You chose not to save the output.
)

pause
