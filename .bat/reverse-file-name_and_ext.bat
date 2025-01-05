@echo off
setlocal enabledelayedexpansion

echo HIDE ANYTHING IN PLAIN SIGHT - Reverses file names and extensions
echo.
echo Please enter the file path(s) or drag and drop file(s) into this window.
echo Multiple files should be separated by spaces.
echo.
set /p "files=Enter file path(s): "

echo.
echo Processing files...
echo.

@REM for %%F in (%files%) do (
@REM     set "fullpath=%%~fF"
@REM     set "name=%%~nF"
@REM     set "ext=%%~xF"
    
@REM     set "revname="
@REM     set "revext="
    
@REM     rem Reverse the name
@REM     for /L %%i in (1,1,!name:~1,-1!) do (
@REM         set "revname=!name:~-%%i,1!!revname!"
@REM     )
    
@REM     rem Reverse the extension (excluding the dot)
@REM     if not "!ext!"=="" (
@REM         for /L %%i in (2,1,!ext:~1,-1!) do (
@REM             set "revext=!ext:~-%%i,1!!revext!"
@REM         )
@REM         set "revext=.!revext!"
@REM     )
    
@REM     rem Rename the file
@REM     ren "!fullpath!" "!revname!!revext!"
    
@REM     echo Renamed: !fullpath! to !revname!!revext!
@REM )

for %%F in (%files%) do (
    set "fullpath=%%~fF"
    set "name=%%~nF"
    set "ext=%%~xF"
    
    set "revname="
    set "revext="
    
    rem Reverse the name
    for /L %%i in (0,1,300) do if "!name:~%%i,1!" neq "" set "revname=!name:~%%i,1!!revname!"
    
    rem Reverse the extension (excluding the dot)
    if not "!ext!"=="" (
        for /L %%i in (1,1,300) do if "!ext:~%%i,1!" neq "" set "revext=!ext:~%%i,1!!revext!"
        set "revext=.!revext!"
    )
    
    rem Rename the file
    ren "!fullpath!" "!revname!!revext!"
    
    echo Renamed: !fullpath! to !revname!!revext!
)

echo.
echo Process completed.
pause
