:: ============================================================================================
:: Open ChatGPT via PowerToys Copilot Key
::
:: PowerToys Setup:
:: 1. Run PowerToys in Admin mode.
:: 2. Go to Keyboard Manager > Shortcuts.
:: 3. Assign Win+Shift+F23 (yes, F23!) as the Copilot key.
:: 4. Set this batch script as the program to execute.
::
:: Why use this script?
:: - PowerToys' "Open URL" action often fails with errors.
:: - This script ensures ChatGPT opens reliably.
::
:: Update:
:: Added an empty title ("") in start to prevent an extra command window flash.
:: ============================================================================================

@echo off
start "" "https://chatgpt.com/"
