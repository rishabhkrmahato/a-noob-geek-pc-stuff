# ================================================================================================
# Description:
# Largest & Smallest File Finder (Modified)
# 
# This script scans the current directory to find the largest and smallest files.
# It dynamically detects the calling `.bat` file (if executed via a batch script) 
# and excludes it from the analysis, along with the PowerShell script itself.
#
# Key Features:
# - Finds the largest and smallest files in the directory.
# - Dynamically detects and excludes the calling `.bat` file.
# - Displays file sizes in human-readable format (B, KB, MB, GB).
# - Uses `Get-ChildItem` to fetch file details.
#
# Hard-Coded Details:
# - The script excludes itself (`max-min-file.ps1`).
# - It also excludes the `.bat` file that called this script, if applicable.
#
# Steps to Update Hard-Coded Details:
# 1. Modify the exclusion conditions in `Where-Object` to ignore additional files.
# 2. Run the script from the desired folder to analyze different directories.
#
# Usage:
# - Run the script inside the folder you want to analyze.
# - If executed via a `.bat` script, that `.bat` file will be excluded.
#
# Dependencies:
# - Standard PowerShell commands (`Get-ChildItem`, `Sort-Object`).
#
# Output:
# - Displays the largest and smallest file names and their sizes.
#
# Error Handling:
# - Exits if no valid files are found.
#
# Notes:
# - This script does not search subdirectories; it only analyzes the current folder.
# - Useful for quickly identifying file size variations in a directory.
# ================================================================================================


# PowerShell Script to Find the Largest & Smallest File in a Folder (modified to find the calling .bat)

# Step 1: Find the calling .bat file dynamically
$parentProcess = Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -eq $PID } | Select-Object -ExpandProperty ParentProcessId
$batFile = Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -eq $parentProcess } | Select-Object -ExpandProperty CommandLine

# Extract the actual .bat file name (if exists)
if ($batFile -match '"?([^"]+\.bat)"?') {
    $batFile = [System.IO.Path]::GetFileName($matches[1])
} else {
    $batFile = $null
}

# Step 2: Get all files, excluding the PowerShell script itself & calling .bat
$files = Get-ChildItem -File | Where-Object { $_.Name -ne "max-min-file.ps1" -and $_.Name -ne $batFile }

if ($files.Count -eq 0) {
    Write-Host "No valid files found!" -ForegroundColor Red
    pause
    exit
}

$largest = $files | Sort-Object Length -Descending | Select-Object -First 1
$smallest = $files | Sort-Object Length | Select-Object -First 1

# Function to Format File Size into KB, MB, GB
function FormatSize([long]$size) {
    if ($size -ge 1GB) { '{0:N2} GB' -f ($size / 1GB) }
    elseif ($size -ge 1MB) { '{0:N2} MB' -f ($size / 1MB) }
    elseif ($size -ge 1KB) { '{0:N2} KB' -f ($size / 1KB) }
    else { '{0} B' -f $size }
}

# Output
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "  File Size Analysis" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""
Write-Host ("  Largest File:  " + $largest.Name) -ForegroundColor Yellow
Write-Host ("  Size:          " + (FormatSize $largest.Length)) -ForegroundColor Yellow
Write-Host ""
Write-Host ("  Smallest File: " + $smallest.Name) -ForegroundColor Green
Write-Host ("  Size:          " + (FormatSize $smallest.Length)) -ForegroundColor Green
Write-Host ""
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

pause
