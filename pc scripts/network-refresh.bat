:: edit out REM if u want to add the commands to run

@echo off
echo Refreshing network connections...

ipconfig /flushdns
echo DNS cache flushed.

REM ipconfig /release
REM echo IP address released.

REM ipconfig /renew
REM echo IP address renewed.

REM netsh int ip reset
REM echo TCP/IP stack reset.

netsh winsock reset
echo Winsock reset.

REM netsh interface ip delete arpcache
REM echo ARP cache cleared.

REM route -f
REM echo Routing table cleared.

REM echo Restarting computer...
REM shutdown /r /f /t 0

pause
