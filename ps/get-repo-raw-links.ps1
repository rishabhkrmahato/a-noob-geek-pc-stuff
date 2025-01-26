# ================================================================================================
#
# Description:
#
# Generate Raw GitHub File URLs
#
# This PowerShell script generates a list of raw file URLs for all files 
# in a local GitHub repository and saves the results to a specified text file. 
# The script is hard-coded with specific details for a repository, which can 
# be updated to work with other repositories.
#
# Key Features:
# - Iterates through all files in the specified local GitHub repository path.
# - Constructs raw GitHub URLs for each file based on the provided repository details.
# - Saves the file names and their corresponding raw URLs to a text file.
#
# Hard-Coded Details:
# - `$username`: The GitHub username associated with the repository.
# - `$repo`: The repository name.
# - `$branch`: The branch name to fetch raw file URLs.
# - `$localRepoPath`: The local file system path of the cloned repository.
# - `$outputFile`: The file path where the output list of raw URLs will be saved.
#
# Steps to Update Hard-Coded Details:
# 1. Update `$username` with your GitHub username.
# 2. Update `$repo` with the name of your GitHub repository.
# 3. Update `$branch` to the relevant branch name (e.g., "main" or "master").
# 4. Update `$localRepoPath` to the full path of the cloned repository on your system.
# 5. Update `$outputFile` with the desired file path for saving the raw URLs.
#
# Usage:
# - Clone the desired repository locally and specify its path in `$localRepoPath`.
# - Run the script to generate a list of raw URLs for all files in the repository.
# - The generated list will be saved in the file specified by `$outputFile`.
#
# Output:
# - A text file containing file names and their corresponding raw GitHub URLs in the format:
#   `<FileName>: <RawGitHubURL>`
#
# Error Handling:
# - Ensure the specified `$localRepoPath` is a valid directory containing a cloned repository.
# - Verify that the GitHub repository and branch names match the actual repository details.
#
# Notes:
# - This script is configured for the GitHub user `rishabhkrmahato` and their repository 
#   `a-noob-geek-pc-stuff`. Update the variables as described to adapt it for other users 
#   or repositories.
# ================================================================================================

# Set your specific details

$username = "rishabhkrmahato"
$repo = "a-noob-geek-pc-stuff"
$branch = "main"
$localRepoPath = "C:\Users\mahat\Documents\GitHub\a-noob-geek-pc-stuff"
$outputFile = "C:\Users\mahat\Documents\GitHub\rkmtoolslist.txt"

# Navigate to the repository folder
Set-Location -Path $localRepoPath

# Get all files recursively in the repo
$files = Get-ChildItem -Recurse -File

# Loop through each file to generate the raw URL
foreach ($file in $files) {
    # Construct the relative path and create the raw URL
    $relativePath = $file.FullName.Substring($localRepoPath.Length + 1).Replace("\", "/")
    $rawUrl = "https://raw.githubusercontent.com/$username/$repo/refs/heads/$branch/$relativePath"
    
    # Write each file name and its raw URL to the output file
    "$($file.Name): $rawUrl" | Out-File -Append $outputFile
}

Write-Output "File URLs have been written to $outputFile"
