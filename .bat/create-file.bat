@echo off
setlocal enabledelayedexpansion

:: Prompt for the filename (with extension)
:filename
set /p filename=Enter the filename (with extension): 

:: Check for invalid characters using findstr for efficiency
echo %filename% | findstr /r /c:"[\\/:*?\"<>|]" >nul
if %errorlevel% neq 1 (
    echo Invalid characters detected (\ / : * ? \" < > |). Please enter a valid filename.
    goto filename
)

:: Ensure the filename contains a dot for extension
echo %filename% | findstr "\." >nul
if %errorlevel% neq 0 (
    echo The file must include an extension (e.g., myfile.txt).
    goto filename
)

:: Ask for the file size in MB
:size
set /p size=Enter the file size in MB: 

:: Validate that the input is numeric only
echo %size% | findstr /r /c:"^[0-9][0-9]*$" >nul
if %errorlevel% neq 0 (
    echo Invalid input. Please enter a valid number.
    goto size
)

:: Create the file using fsutil
fsutil file createnew "%filename%" %size%000000

:: Check if the file creation was successful
if %errorlevel% neq 0 (
    echo Failed to create file. Ensure you have permissions and sufficient disk space.
) else (
    echo File created successfully: %CD%\%filename%
)

pause
exit
