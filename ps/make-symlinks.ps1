# ================================================================================================
# Description:
# Create Symbolic Links in System32
# 
# This PowerShell script creates symbolic links for all files in a specified 
# source folder and places them in the `System32` directory. This allows quick 
# access to scripts or executables from anywhere in the command line.
#
# Key Features:
# - Reads all files from the specified source directory.
# - Creates symbolic links in `C:\Windows\System32` for easy execution.
# - Uses `-Force` to overwrite existing links if necessary.
#
# Hard-Coded Details:
# - `$sourceFolder`: The folder containing the original scripts/files.
# - `$targetFolder`: The `System32` directory where symbolic links will be created.
#
# Steps to Update Hard-Coded Details:
# 1. Modify `$sourceFolder` to match the directory containing your scripts or executables.
# 2. If you want links to be created in a different location, change `$targetFolder`.
#
# Usage:
# - Run the script with administrative privileges.
# - Ensure that `$sourceFolder` contains valid files before executing the script.
#
# Dependencies:
# - PowerShell 5.1 or later.
# - Administrator privileges to modify `System32`.
#
# Output:
# - Creates symbolic links in `C:\Windows\System32` for all files from `$sourceFolder`.
#
# Error Handling:
# - Skips files that cannot be linked due to permission issues.
# - Uses `-Force` to ensure old links are replaced without manual intervention.
#
# Notes:
# - This script is configured for the GitHub user `rishabhkrmahato` and their 
#   repository `a-noob-geek-pc-stuff`. Update the paths accordingly.
# - Running this script without admin rights will result in errors.
# ================================================================================================

$sourceFolder = "C:\Users\mahat\Documents\GitHub\a-noob-geek-pc-stuff\.bat\shortcuts-i-have-in-system32"
$targetFolder = "$env:SystemRoot\System32"

Get-ChildItem $sourceFolder | ForEach-Object {
    $link = Join-Path $targetFolder $_.Name
    New-Item -ItemType SymbolicLink -Path $link -Target $_.FullName -Force
}
