:: Make sure to call in ADMIN terminal when required.

@echo off
setlocal enabledelayedexpansion

:: Prompt user for the source path(s)
set /p sources="Enter source file or folder path(s): "

:: Process each source input
for %%A in (%sources%) do (
    set "source=%%~A"
    set "source=!source:"=!"  &:: Remove surrounding quotes if present

    :: Validate existence
    if not exist "!source!" (
        echo ERROR: "!source!" does not exist. Please check the path and try again.
        echo Make sure to enter correct paths, check for spaces, and use quotes if necessary.
        echo Example: "C:\path with spaces\file.txt" or multiple files: "file1.txt" "file2.txt"
        pause
        exit /b
    )

    :: Get filename or folder name
    for %%F in ("!source!") do set "name=%%~nxF"

    :: Get current directory (where script is executed)
    set "targetDir=%CD%"

    :: Determine if it's a file or a directory
    if exist "!source!\*" (
        :: It's a directory
        mklink /D "!targetDir!\!name!" "!source!" >nul 2>&1
        set "type=Directory"
    ) else (
        :: It's a file
        mklink "!targetDir!\!name!" "!source!" >nul 2>&1
        set "type=File"
    )

    :: Notify user
    if !errorlevel! == 0 (
        echo Symlink created successfully for !type!: "!name!"
    ) else (
        echo Failed to create symlink for !type! "!name!". Ensure you have administrative privileges.
    )
)
@REM pause
