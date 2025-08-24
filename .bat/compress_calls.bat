@echo off
setlocal enabledelayedexpansion

:: Create output folder
set "outdir=%cd%\compressed"
if not exist "%outdir%" mkdir "%outdir%"

:: Loop through all audio files in current folder
for %%f in (*.wav *.m4a *.mp3 *.aac *.amr *.ogg) do (
    echo Compressing: %%f
    ffmpeg -i "%%f" -c:a libopus -b:a 12k -ac 1 "%outdir%\%%~nf.opus"
)

echo.
echo Done! All compressed files saved in: %outdir%
pause
