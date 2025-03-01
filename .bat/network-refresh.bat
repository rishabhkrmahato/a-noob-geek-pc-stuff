:: ================================================================================================
:: Description:
:: Quick Network Refresh
:: 
:: This batch script refreshes network settings to resolve connectivity 
:: issues by flushing the DNS cache, resetting Winsock, and optionally 
:: releasing/renewing the IP address.
::
:: Key Features:
:: - Flushes the DNS cache to resolve slow website name lookups.
:: - Resets Winsock to fix potential socket and network connection issues.
:: - (Optional) Releases and renews the IP address (commented out by default).
:: - Restarts active network adapters without requiring a system reboot.
::
:: Usage:
:: - Run the script as an administrator for full functionality.
:: - Uncomment the `ipconfig /release` and `ipconfig /renew` lines for 
::   a full IP address refresh.
::
:: Dependencies:
:: - Requires administrative privileges.
::
:: Output:
:: - Displays progress messages for each network action performed.
::
:: Error Handling:
:: - Skips actions if they fail but continues execution.
:: - Uses a timeout to ensure proper restart of the network adapter.
::
:: Notes:
:: - Useful for resolving slow internet, connectivity drops, or DNS issues.
:: - Restarting the network adapter may temporarily disconnect active connections.
:: ================================================================================================


@echo off
title Quick Network Refresh
echo Refreshing network settings...

:: Flush DNS cache (Resolves slow name lookups)
ipconfig /flushdns
echo DNS cache flushed.

:: Reset Winsock (Fixes potential socket issues)
netsh winsock reset
echo Winsock reset completed.

:: Release and renew IP (Uncomment if you want a full IP refresh)
REM ipconfig /release
REM echo IP address released.

REM ipconfig /renew
REM echo IP address renewed.

:: Restart network adapter (Avoids full system reboot)
echo Restarting network adapter...
for /f "tokens=2 delims=:" %%a in ('wmic nic where "NetConnectionStatus=2" get NetConnectionID /value') do (
    netsh interface set interface "%%a" admin=disable
    timeout /t 2 >nul
    netsh interface set interface "%%a" admin=enable
)
echo Network adapter restarted.

echo Done!  Network Refreshed.
pause
