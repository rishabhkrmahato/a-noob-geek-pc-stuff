@echo off
REM Define the output file path
set "output_file=%USERPROFILE%\Desktop\ImportantFiles.txt"

REM Clear the output file if it already exists
if exist "%output_file%" del "%output_file%"

REM Define the directories to check
setlocal
set "dirs=%USERPROFILE%\Downloads %USERPROFILE%\Documents %USERPROFILE%\Pictures %USERPROFILE%\Music %USERPROFILE%\Videos"

REM List files in each directory and save to the output file
(
    for %%d in (%dirs%) do (
        if exist "%%d" (
            echo Files in %%d:
            dir "%%d" /b /s
            echo.
        )
    )
    echo Check for important files in the Recycle Bin.
) > "%output_file%"
endlocal
