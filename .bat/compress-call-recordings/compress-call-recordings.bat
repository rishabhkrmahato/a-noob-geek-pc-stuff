@echo off
setlocal enabledelayedexpansion

:: ------------------------------------------------------------------
::  Compress Call Recordings Script
::  Author : Rishabh (Sonu)
::  Description : Batch convert all audio files in current folder
::                into highly compressed OPUS format (for speech).
::  Requirements : ffmpeg (must be in PATH)
:: ------------------------------------------------------------------

:: === Title and banner ===
title Call Recordings Compressor
echo ============================================================
echo      Call Recordings Compressor - OPUS 12 kbps
echo ============================================================
echo.

:: === Check for ffmpeg ===
where ffmpeg >nul 2>nul
if errorlevel 1 (
    echo [ERROR] ffmpeg not found in PATH.
    echo Install it via: scoop install ffmpeg
    echo Exiting...
    pause
    exit /b 1
)

:: === Prepare output folder ===
set "outdir=%cd%\compressed"
if not exist "%outdir%" mkdir "%outdir%"

:: === Track file count ===
set /a count=0
set /a success=0
set /a fail=0

:: === Process each supported audio file ===
for %%f in (*.wav *.m4a *.mp3 *.aac *.amr *.ogg *.flac) do (
    set /a count+=1
    echo [%%~nf] -> Compressing...
    ffmpeg -loglevel error -y -i "%%f" -c:a libopus -b:a 12k -ac 1 "%outdir%\%%~nf.opus"
    if errorlevel 1 (
        echo    [ERROR] Failed: %%f
        set /a fail+=1
    ) else (
        echo    [OK] Saved: compressed\%%~nf.opus
        set /a success+=1
    )
)

:: === Final report ===
echo.
echo ============================================================
echo   >> Compression Completed
echo ------------------------------------------------------------
echo   Total files   : %count%
echo   Successful    : %success%
echo   Failed        : %fail%
echo   Output folder : %outdir%
echo ============================================================
echo.
pause
endlocal
