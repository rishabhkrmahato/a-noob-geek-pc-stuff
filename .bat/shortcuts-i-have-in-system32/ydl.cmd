@echo off
set SCRIPT_URL="https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/main/py/BEST-YOUTUBE-DOWNLOADER.py"
set TEMP_SCRIPT_PATH="%TEMP%\temp-BEST-YOUTUBE-DOWNLOADER.py"
powershell -NoProfile -ExecutionPolicy Bypass -Command "(Invoke-WebRequest -Uri %SCRIPT_URL% -UseBasicParsing).Content | Out-File -Encoding UTF8 %TEMP_SCRIPT_PATH%"
python %TEMP_SCRIPT_PATH% %*
if exist %TEMP_SCRIPT_PATH% (
    del %TEMP_SCRIPT_PATH%
)
goto :eof