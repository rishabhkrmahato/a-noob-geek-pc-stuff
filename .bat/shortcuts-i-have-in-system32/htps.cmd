:: ================================================================================================
:: Description:
:: Local HTTP Server with No Cache
:: 
:: This script starts an HTTP server in the current directory using `http-server`
:: and opens the local server in the default web browser with a cache-busting mechanism.
::
:: Key Features:
:: - Uses a custom port (default: `54321`) to avoid conflicts.
:: - Automatically detects and handles root directory cases properly.
:: - Starts the server in a minimized command window.
:: - Ensures the browser fetches a fresh version by appending `?nocache=random`.
::
:: Hard-Coded Details:
:: - The server runs on `PORT=54321` (Modify as needed).
:: - Uses `http-server` (requires Node.js and `http-server` package).
::
:: Steps to Update Hard-Coded Details:
:: 1. Change the `PORT` variable if another port is preferred.
:: 2. Ensure `http-server` is installed (`npm install -g http-server`).
:: 3. Modify the cache-busting method if needed (`?nocache=%random%`).
::
:: Usage:
:: - Run this script in the directory containing files to serve.
:: - The browser will automatically fetch the latest version (no need to press F5).
::
:: Dependencies:
:: - Requires Node.js and `http-server` (`npm install -g http-server`).
::
:: Output:
:: - Starts the server and opens `http://127.0.0.1:54321/?nocache=random` in the default browser.
::
:: Error Handling:
:: - Ensures correct path formatting for root directories.
:: - Opens the server in a new minimized command window.
::
:: Notes:
:: - The script prevents browser caching issues by appending a random query parameter.
:: - Useful for live-reloading static files without manually refreshing.
:: ================================================================================================


@echo off
setlocal

:: Define a custom rare port
set "PORT=54321"

:: Get the current directory
set "DIR=%CD%"

:: If at root (D:), ensure it becomes D:\ (handles root cases properly)
if "%DIR:~-1%"==":" set "DIR=%DIR%\" 

:: Remove accidental quotes
set "DIR=%DIR:"=%"

:: Start server in a new minimized window
if "%DIR%"=="%CD:~0,2%\" (
    start /min cmd /c "http-server %DIR% -p %PORT%"
) else (
    start /min cmd /c "http-server "%DIR%" -p %PORT%"
)

:: Wait briefly for the server to start
timeout /t 1 >nul

:: Open in default browser
@REM start http://127.0.0.1:%PORT%
::force browser to fetch fresh version, no previous caching issue.
start "" "http://127.0.0.1:54321/?nocache=%random%" 
