@echo off
setlocal enabledelayedexpansion

:: ------------------------------------------------------------------
::  Compress Call Recordings Script (Improved & Minimal)
::  Author   : Rishabh (Sonu)
::  Purpose  : Batch convert all audio files in current folder
::             into highly compressed OPUS format (speech-optimized).
::  Requires : ffmpeg in PATH
:: ------------------------------------------------------------------

:: Output folder
set "outdir=%~dp0compressed"
if not exist "%outdir%" mkdir "%outdir%"

echo.
echo ---------------------------------------------------------------
echo   Compressing audio files in: %cd%
echo   Output will be saved to:   %outdir%
echo ---------------------------------------------------------------
echo.

:: Process all audio files
for %%F in (*.mp3 *.wav *.m4a *.aac *.flac *.ogg) do (
    echo Processing: %%F
    ffmpeg -hide_banner -loglevel error -i "%%F" -c:a libopus -b:a 16k "%outdir%\%%~nF.opus"
    if !errorlevel! == 0 (
        echo   [OK] Done
    ) else (
        echo   [ERR] Failed
    )
)

echo.
echo ---------------------------------------------------------------
echo   All files processed.
echo   Press any key to exit...
echo ---------------------------------------------------------------
pause >nul
endlocal
