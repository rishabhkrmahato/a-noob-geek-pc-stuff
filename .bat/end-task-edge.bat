:: ================================================================================================
:: Description:
:: Force Close Microsoft Edge
::
:: This script forcefully terminates all running Microsoft Edge processes, 
:: even when background activity is disabled in settings.
::
:: Usage:
:: - Run the script to close all Edge instances.
::
:: Output:
:: - Displays confirmation after closing Edge.
::
:: Notes:
:: - Edge may restart if set as the default browser with background tasks enabled.
:: ================================================================================================


@echo off
:: edge runs in the background with upto 15 processes, even without signed in, and run edge in background turned off in settings

taskkill /F /IM msedge.exe
echo Microsoft Edge has been completely closed.
pause
