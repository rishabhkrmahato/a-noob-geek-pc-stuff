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
