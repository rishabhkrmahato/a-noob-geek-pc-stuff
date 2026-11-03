@echo off
setlocal
echo Magnet and .torrent association registry file generator
echo.
echo A file picker will open. Select the program (.exe) you want to associate
echo with magnet links and .torrent files.
echo A Save As dialog will then let you choose where to save the .reg file.
echo This tool creates the file only; it does not import it into the registry.
echo.
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0Create-MagnetTorrentReg.ps1"
if errorlevel 1 (
  echo.
  echo The generator encountered an error. See the message above.
) else (
  echo.
  echo Finished. If you saved a .reg file, double-click it to import it.
  echo Then choose the app for magnet and .torrent in Windows Default apps.
)
echo.
echo Press any key to close this window.
pause >nul
endlocal