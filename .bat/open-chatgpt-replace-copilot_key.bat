:: ==============================================
:: Use PowerToys (always in Admin mode)
:: Go to Keyboard Manager > Shortcuts
:: Assign Win+Shift+F23 (yes, F23!) as the Copilot key
:: Use this as a program, since the 'Open URL' in PowerToys often gives an error
:: ==============================================

@echo off
start https://chatgpt.com/

:: ==============================================
:: or use firefox as program & set https://chatgpt.com/ in args
:: but launching firefox from ahk/scripts/powertoys i don't why forces it to open in safe mode, and pops an error msg first
:: hence this simple bat
:: ==============================================