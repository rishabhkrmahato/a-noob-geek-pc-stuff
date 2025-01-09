# ================================================================================================
# Description:
# 
# Combine Scripts into Single File
# 
# This script combines the content of supported script files 
# (e.g., .bat, .ps1, .py, etc.) from a specified folder into 
# a single output file. It dynamically names the output file 
# based on the folder name, and adds headers for each file.
#
# Key Features:
# - Supports customizable file extensions.
# - Skips invalid paths and prevents processing the output file itself.
# - Adds readability with headers and separators between file contents.
# - Clears the output file if it already exists before processing.
#
# Usage:
# - Run the script and provide the folder path containing the scripts.
# - The output will be saved in the same folder as a text file.
#
# Output:
# The combined scripts are saved in `combined_script_codes_(FolderName).txt`.
# ================================================================================================

# Prompt the user for the folder containing the scripts
Write-Host "Enter the folder path containing the scripts:" -ForegroundColor Cyan
$inputPath = Read-Host

# Clean up the folder path (remove quotes if present)
$scriptDirectory = $inputPath.Trim('"').Trim("'")

# Check if the path is valid
if (-Not (Test-Path $scriptDirectory)) {
    Write-Host "Invalid path. Please try again." -ForegroundColor Red
    exit
}

# Extract the folder name for dynamic output file naming
$folderName = Split-Path -Path $scriptDirectory -Leaf
$outputFile = "$scriptDirectory\combined_script_codes_($folderName).txt"

# Clear existing output file if it exists
if (Test-Path $outputFile) {
    Remove-Item -Path $outputFile
}

# Supported file extensions (add or remove extensions as needed)
$supportedExtensions = @("*.bat", "*.ps1", "*.py", "*.cpp", "*.sh", "*.txt")

# Process each file and combine the contents
foreach ($extension in $supportedExtensions) {
    $scriptFiles = Get-ChildItem -Path $scriptDirectory -Filter $extension

    foreach ($file in $scriptFiles) {
        # Skip the output file itself to avoid processing it
        if ($file.FullName -eq $outputFile) {
            continue
        }

        # Add file header to the output
        Add-Content -Path $outputFile -Value "=============================="
        Add-Content -Path $outputFile -Value "File: $($file.Name)"
        Add-Content -Path $outputFile -Value "=============================="
        Add-Content -Path $outputFile -Value ""

        # Add the file content to the output
        Get-Content -Path $file.FullName | Add-Content -Path $outputFile

        # Add a separator for readability
        Add-Content -Path $outputFile -Value "`n"
    }
}

Write-Host "All scripts have been combined into $outputFile" -ForegroundColor Green
