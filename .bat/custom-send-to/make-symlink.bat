@echo off
setlocal

:: ============================================================================
:: MakeSymlink.bat - Create Symbolic Link via Windows Send To Menu
:: ============================================================================
::
:: PURPOSE:
::   Creates a symbolic link (symlink) of a selected file or folder in the
::   same directory as the original item. Integrates with the Windows
::   "Send To" right-click menu.
::
:: REQUIREMENTS:
::   Creating symbolic links usually requires Administrator privileges.
::   You have TWO options to achieve this:
::
::   OPTION 1: Configure Shortcut to Run as Administrator (Default method)
::     - The shortcut you place in the "Send To" folder MUST be set to
::       "Run as administrator".
::     - This will trigger a User Account Control (UAC) prompt each time.
::
::   OPTION 2: Enable Windows Developer Mode (No UAC prompt for symlinks)
::     - If you enable Developer Mode in Windows settings, standard users
::       can create symlinks without explicit admin elevation.
::     - HOW TO ENABLE: Go to Settings > Update & Security > For developers
::       (or Settings > Privacy & security > For developers in Win 11)
::       and turn on "Developer Mode". Read the notice before enabling.
::     - If Developer Mode is ON, you DO NOT need to set the shortcut to
::       "Run as administrator" (Option 1).
::
:: SETUP INSTRUCTIONS:
::
::   1. SAVE THE SCRIPT:
::      - Save this code as a batch file (e.g., "MakeSymlink.bat") in a
::        permanent location (like C:\Scripts or Documents).
::      - In Notepad, use File > Save As, set "Save as type" to "All Files",
::        and ensure the filename ends with ".bat".
::
::   2. ADD SHORTCUT TO "SEND TO" FOLDER:
::      - Press Win + R, type `shell:sendto`, and press Enter.
::      - Navigate to where you saved "MakeSymlink.bat".
::      - RIGHT-CLICK and DRAG "MakeSymlink.bat" into the "Send To" folder.
::      - Release the mouse button and select "Create shortcuts here".
::      - Rename the shortcut if desired (e.g., "Make Symlink").
::
::   3. CONFIGURE SHORTCUT (Only if NOT using Developer Mode):
::      - If you did NOT enable Developer Mode (Option 2), you MUST do this:
::      - Right-click the shortcut you just created in the "Send To" folder.
::      - Select "Properties".
::      - Go to the "Shortcut" tab.
::      - Click the "Advanced..." button.
::      - Check the box "Run as administrator".
::      - Click OK, then OK again.
::
:: USAGE:
::
::   1. Right-click the file or folder you want to link.
::   2. Go to the "Send to" sub-menu.
::   3. Click the "Make Symlink" shortcut.
::   4. If you configured Option 1, approve the UAC prompt.
::   5. A symlink named "[Original Name] - Symlink[.Original Extension]"
::      will be created in the same folder.
::
:: ============================================================================

:: Check if an argument (the file/folder path) was passed
if "%~1"=="" (
    echo Error: No file or folder specified.
    echo Drag and drop a file/folder onto the script or use Send To menu.
    pause
    exit /b 1
)

:: Store the full path of the target file/folder
set "targetPath=%~1"

:: Check if the target exists
if not exist "%targetPath%" (
    echo Error: Target path does not exist:
    echo "%targetPath%"
    pause
    exit /b 1
)

:: Extract parts of the path
set "targetDir=%~dp1"
set "targetName=%~n1"
set "targetExt=%~x1"

:: Construct the name for the new symlink
set "linkName=%targetName% - Symlink%targetExt%"
set "linkPath=%targetDir%%linkName%"

:: Check if a file/folder with the link name already exists
if exist "%linkPath%" (
    echo A file or folder named "%linkName%" already exists in:
    echo "%targetDir%"
    choice /M "Do you want to overwrite it?"
    if errorlevel 2 exit /b 1
    echo Attempting to remove existing file/folder...
    del /f /q "%linkPath%" 2>nul || rd /s /q "%linkPath%" 2>nul
)

echo Creating symlink for: "%targetPath%"
echo Link name:          "%linkName%"
echo In directory:       "%targetDir%"
echo.

:: Determine if the target is a directory
dir /ad "%targetPath%" >nul 2>&1
if not errorlevel 1 (
    echo Target is a directory. Creating directory symlink...
    mklink /D "%linkPath%" "%targetPath%" >nul
) else (
    echo Target is a file. Creating file symlink...
    mklink "%linkPath%" "%targetPath%" >nul
)

:: Check if mklink succeeded
if errorlevel 1 (
    echo.
    echo ERROR: Failed to create symbolic link.
    echo.
    echo Possible Reasons:
    echo   - Lack of Administrator privileges (if Developer Mode is OFF).
    echo   - Target or Link path is on an unsupported file system (e.g., FAT32).
    echo   - Path contains invalid characters or permissions issue.
    echo.
    echo If Developer Mode is OFF, ensure the shortcut in 'shell:sendto'
    echo is configured to 'Run as administrator'.
    pause
    exit /b %ERRORLEVEL%
) else (
    echo.
    echo Symbolic link created successfully!
    timeout /t 1 /nobreak >nul
)

endlocal
exit /b 0
