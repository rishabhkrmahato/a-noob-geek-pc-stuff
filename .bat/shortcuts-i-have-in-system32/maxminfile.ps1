# ================================================================================================
# Description:
# Largest & Smallest File Finder
# 
# This script scans the current directory to find the largest and smallest 
# files, excluding itself (`max-min-file.ps1`) and the batch launcher (`max-min-file.bat`).
#
# Key Features:
# - Finds the largest and smallest files in the directory.
# - Displays file sizes in human-readable format (B, KB, MB, GB).
# - Uses `Get-ChildItem` to fetch file details.
# - Ignores script files to avoid incorrect results.
#
# Hard-Coded Details:
# - The script excludes itself (`max-min-file.ps1`, `max-min-file.bat`).
#   [If renaming, ensure both files have the same name.]
# 
# Steps to Update Hard-Coded Details:
# 1. Modify the exclusion list if additional files need to be ignored.
# 2. Run the script from the desired folder to analyze different directories.
#
# Usage:
# - Run the script inside the folder you want to analyze.
# - The script will display the largest and smallest files with their sizes.
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
# ================================================================================================


# PowerShell Script to Find the Largest & Smallest File in a Folder

$files = Get-ChildItem -File | Where-Object { $_.Name -notin @("max-min-file.ps1", "max-min-file.bat") }

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
