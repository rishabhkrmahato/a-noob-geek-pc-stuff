@echo off
setlocal

:: Find MPC-HC (checks both 32-bit and 64-bit locations)
for %%P in ("%ProgramFiles%\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe" "%ProgramFiles%\K-Lite Codec Pack\MPC-HC\mpc-hc.exe" "%ProgramFiles(x86)%\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe" "%ProgramFiles(x86)%\K-Lite Codec Pack\MPC-HC\mpc-hc.exe") do (
    if exist "%%~P" set "MPC_PATH=%%~P"
)

:: If not found, show error and exit
if not defined MPC_PATH (
    echo Error: MPC-HC not found. Please install K-Lite Mega Codec Pack. 
    echo Download: https://codecguide.com/download_k-lite_codec_pack_mega.htm
    pause
    exit /b
)

:: Process each file passed as an argument
for %%i in (%*) do (
    echo.
    echo Generating thumbnails for "%%~i"
    "%MPC_PATH%" /thumbnails "%%~i"
    echo Done with "%%~i"
)

endlocal
