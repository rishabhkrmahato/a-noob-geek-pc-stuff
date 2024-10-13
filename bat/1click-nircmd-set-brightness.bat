@echo off

:: windows does not have native brightness control command line utility
:: get nircmd from nirsoft, its a multipurpose great cmd utility
:: add it to path or same system folder (faster way): unzip the contents and move nircmd.exe and nircmdc.exe to "C:\Windows\System32"

nircmd.exe setbrightness 75 
::change this to your desired value and rename the file, eg. set brightness to 75%.bat


