:: Functionality:
:: 1. Creates a folder named "f o l d e r" on the desktop if it doesn't exist
:: 2. Prompts for password creation on first use
:: 3. Toggles folder visibility (hide/unhide) on subsequent runs
:: 4. Uses Windows dialog boxes for password input and notifications
:: 5. Applies hidden and system attributes for increased security

:: Usage:
:: 1. Save this file as "folderlock.bat" on your desktop or preferred location
:: 2. Double-click the file to run it
:: 3. Set a password when prompted on first run
:: 4. Enter the password to toggle folder visibility on subsequent runs

@echo off
setlocal enabledelayedexpansion

set "folder=%USERPROFILE%\Desktop\f o l d e r"
set "vbs=%temp%\promptpwd.vbs"
set "pwdfile=%folder%\.password"

if not exist "%folder%" (
    mkdir "%folder%"
    call :setpassword
) else (
    call :checkpassword
)

exit /b

:setpassword
echo Set objShell = CreateObject("WScript.Shell") > "%vbs%"
echo password = InputBox("Set a password for the folder:","Set Password","") >> "%vbs%"
echo WScript.Echo password >> "%vbs%"
for /f "delims=" %%a in ('cscript //nologo "%vbs%"') do set "pwd=%%a"
echo !pwd!> "%pwdfile%"
attrib +h +s "%pwdfile%"
call :hidefolder
exit /b

:checkpassword
echo Set objShell = CreateObject("WScript.Shell") > "%vbs%"
echo password = InputBox("Enter the password to access the folder:","Enter Password","") >> "%vbs%"
echo WScript.Echo password >> "%vbs%"
for /f "delims=" %%a in ('cscript //nologo "%vbs%"') do set "input=%%a"
set /p pwd=<"%pwdfile%"
if "!input!"=="!pwd!" (
    call :togglefolder
) else (
    echo MsgBox "Incorrect password. Access denied.", vbExclamation, "Error" > "%vbs%"
    cscript //nologo "%vbs%"
)
exit /b

:togglefolder
attrib "%folder%" | find "H" >nul
if errorlevel 1 (
    call :hidefolder
) else (
    call :unhidefolder
)
exit /b

:hidefolder
attrib +h +s "%folder%"
echo MsgBox "Folder locked successfully.", vbInformation, "Success" > "%vbs%"
cscript //nologo "%vbs%"
exit /b

:unhidefolder
attrib -h -s "%folder%"
echo MsgBox "Folder unlocked successfully.", vbInformation, "Success" > "%vbs%"
cscript //nologo "%vbs%"
exit /b
