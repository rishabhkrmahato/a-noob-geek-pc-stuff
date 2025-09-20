:: ================================================================================================
:: Description:
:: Dummy File Creator
::
:: This batch script generates a dummy file of a specified size 
:: using the `fsutil` command in Windows.
::
:: Key Features:
:: - Prompts the user to enter a file name (including extension).
:: - Prompts the user to enter the desired file size in MB.
:: - Converts the given MB value to bytes and creates the file.
:: - Validates the file size input to ensure it is a number.
:: - Displays the full file path upon successful creation.
::
:: Hard-Coded Details:
:: - Uses `fsutil file createnew` to generate the file.
:: - Assumes 1MB = 1,048,576 bytes for conversion.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify `filesizeMB` conversion logic if using a different byte size calculation.
:: 2. Change output messages if needed for customization.
::
:: Usage:
:: - Run the script and enter the desired file name and size in MB.
:: - The generated file will be empty but will take up the specified space.
::
:: Dependencies:
:: - Windows with `fsutil` (requires administrative privileges on some systems).
::
:: Output:
:: - A new empty file of the specified size in the current working directory.
::
:: Error Handling:
:: - Ensures the entered file size is a valid number.
:: - Displays an error message if file creation fails.
::
:: Notes:
:: - This script does not fill the file with actual data, only allocates space.
:: - Some systems may require administrator privileges to use `fsutil`.
:: ================================================================================================


@echo off

:: Get file name from the user
set /p filename="Enter the file name (with extension): "

:: Get file size in MB from the user
set /p filesizeMB="Enter the file size in MB: "

:: Validate input (ensure filesizeMB is a number)
echo %filesizeMB%| findstr /r "^[0-9][0-9]*$" >nul || (
    echo Invalid input! Please enter a valid number for file size.
    pause
    exit /b
)

:: Convert MB to bytes (1MB = 1048576 bytes)
set /a filesize=%filesizeMB%*1048576

:: Create the file using fsutil
fsutil file createnew "%filename%" %filesize% >nul 2>&1 && (
    echo File "%filename%" created successfully.
    echo Full path: %CD%\%filename%
) || echo Failed to create the file. Check your inputs.

pause
