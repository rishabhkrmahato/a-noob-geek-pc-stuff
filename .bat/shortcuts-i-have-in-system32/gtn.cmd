@echo off
setlocal

:: ======================================================
:: MPC-HC Thumbnail Generator - for Rishabh's use
:: 
:: - Auto-detects MPC-HC from K-Lite install.
:: - Accepts one or more video files as arguments.
:: - Generates thumbnail sheets quickly.
:: 
:: Note: Needs K-Lite Codec Pack (Mega) installed.
:: ======================================================

:: Check if any files are provided
if "%~1"=="" (
    echo No files provided.
    echo Drag and drop or run with file paths.
    pause
    exit /b
)

echo Starting Thumbnail Generation...
echo.

:: Find MPC-HC (checks 64-bit and 32-bit locations)
for %%P in (
    "%ProgramFiles%\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe"
    "%ProgramFiles%\K-Lite Codec Pack\MPC-HC\mpc-hc.exe"
    "%ProgramFiles(x86)%\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe"
    "%ProgramFiles(x86)%\K-Lite Codec Pack\MPC-HC\mpc-hc.exe"
) do (
    if exist "%%~P" set "MPC_PATH=%%~P"
)

:: If not found, show error and exit
if not defined MPC_PATH (
    echo Error: MPC-HC not found!
    echo Please install K-Lite Mega Codec Pack: https://codecguide.com/download_k-lite_codec_pack_mega.htm
    pause
    exit /b
)

:: Process each file passed as an argument
for %%i in (%*) do (
    echo Generating thumbnails for: "%%~i"
    "%MPC_PATH%" /thumbnails "%%~i"
    echo Finished: "%%~i"
    echo.
)

echo All Done!
pause
endlocal
