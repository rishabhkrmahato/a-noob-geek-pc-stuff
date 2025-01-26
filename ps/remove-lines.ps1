# ================================================================================================
#
# Description:
#
# Remove Lines with Matching Text
#
# This PowerShell script removes all lines containing a specific pattern 
# of text from a file. The script is hard-coded with specific details for 
# the file path and the text pattern to match. Update these details as 
# needed for your use case.
#
# Key Features:
# - Reads content from a specified file.
# - Filters out lines matching the specified text pattern.
# - Overwrites the original file with the filtered content.
#
# Hard-Coded Details:
# - `$filePath`: Path to the file containing the lines to be filtered.
# - `'C:\\Users\\mahat\\Documents\\GitHub\\a-noob-geek-pc-stuff\\.git\\objects\\'`: 
#   The text pattern to search for and remove from the file.
#
# Steps to Update Hard-Coded Details:
# 1. Update `$filePath` with the full path to your target file.
# 2. Replace the pattern `'C:\\Users\\mahat\\Documents\\GitHub\\a-noob-geek-pc-stuff\\.git\\objects\\'` 
#    with the text pattern you want to remove.
#
# Usage:
# - Provide the path to the file in `$filePath`.
# - Specify the text pattern to remove in the `-notmatch` clause.
# - Run the script to filter and update the file with the desired content.
#
# Output:
# - The original file at `$filePath` is overwritten with the filtered content.
#
# Error Handling:
# - Ensure the file specified in `$filePath` exists and is accessible.
# - Verify that the text pattern correctly matches the lines to remove.
#
# Notes:
# - This script is configured for the file path and text pattern specific 
#   to the user's GitHub repository (`a-noob-geek-pc-stuff`). Update these 
#   details to adapt the script for your use cases.
# ================================================================================================

# i use this to remove multiple lines having a common text eg. here: 
# edit and change it accordingly

$filePath = "C:\Users\mahat\Documents\GitHub\files-in-my-repo.txt"
$text = Get-Content $filePath | Where-Object { $_ -notmatch 'C:\\Users\\mahat\\Documents\\GitHub\\a-noob-geek-pc-stuff\\.git\\objects\\' }
$text | Set-Content $filePath
