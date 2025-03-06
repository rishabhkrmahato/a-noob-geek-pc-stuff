@REM # ================================================================================================
@REM # Description:  
@REM # Batch Launcher for PowerShell  
@REM #   
@REM # Runs `max-min-file.ps1` with execution policy bypassed.  
@REM # Ensures smooth execution from a batch file.  
@REM #
@REM # Usage:  
@REM # - Place this `.bat` file next to `max-min-file.ps1` and run it.  
@REM #
@REM # Notes:  
@REM # - Requires PowerShell on the system.  
@REM # - Simplifies running PowerShell scripts via batch.  
@REM # ================================================================================================

@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0maxminfile.ps1"
