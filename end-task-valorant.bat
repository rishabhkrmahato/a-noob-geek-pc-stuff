@echo off

:: simple batch, just to completely end valorant after done gaming, cause sometimes it runs in the background even after ending.

echo Stopping RiotClient and Valorant processes...

:: Taskkill for Riot and Valorant related processes along with their child processes

taskkill /F /T /IM RiotClientServices.exe
taskkill /F /T /IM RiotClientUx.exe
taskkill /F /T /IM RiotClientUxRender.exe
taskkill /F /T /IM VALORANT.exe
taskkill /F /T /IM VanguardTray.exe
taskkill /F /T /IM vgtray.exe
taskkill /F /T /IM vgc.exe

echo All processes terminated, including child processes.
pause
