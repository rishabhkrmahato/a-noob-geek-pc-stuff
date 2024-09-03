:: edge runs in the background with upto 15 processes, even without signed in, and run edge in background turned off in settings

@echo off
taskkill /F /IM msedge.exe
echo Microsoft Edge has been completely closed.
pause
