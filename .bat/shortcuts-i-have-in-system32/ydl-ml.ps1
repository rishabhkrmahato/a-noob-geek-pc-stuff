
param (
    [Parameter(Mandatory = $true)]
    [string]$InputFile
)

# Function to set colored output
function Write-Color {
    param (
        [string]$Message,
        [string]$Color
    )
    switch ($Color) {
        "Red"    { Write-Host $Message -ForegroundColor Red }
        "Green"  { Write-Host $Message -ForegroundColor Green }
        "Yellow" { Write-Host $Message -ForegroundColor Yellow }
        "Blue"   { Write-Host $Message -ForegroundColor Blue }
        "Cyan"   { Write-Host $Message -ForegroundColor Cyan }
        default  { Write-Host $Message }
    }
}

# Display script title
Write-Host ""
Write-Color "============================================================" "Cyan"
Write-Color "                   YDL-MULTI-LINK DOWNLOADER                " "Yellow"
Write-Color "============================================================" "Cyan"
Write-Color "Usage: ydl-ml.ps1 [file_with_links.txt]" "Green"
Write-Color "Description: Fetches links from the specified text file and downloads each using ydl." "Green"

# Validate input file
if (!(Test-Path $InputFile)) {
    Write-Color "ERROR: File '$InputFile' not found. Ensure the file exists and try again." "Red"
    exit 1
}

# Displaying the input file
Write-Color "Input file: '$InputFile'" "Cyan"
Write-Color "------------------------------------------------------------" "Cyan"
Write-Host ""
Write-Color "Starting download process..." "Yellow"

# Read links from file and process each
Get-Content $InputFile | ForEach-Object {
    $link = $_.Trim()
    if ($link) {
        Write-Host ""
        Write-Color "Downloading: $link" "Blue"
        try {
            & ydl $link
            if ($LASTEXITCODE -eq 0) {
                Write-Color "SUCCESS: Downloaded $link" "Green"
            } else {
                Write-Color "ERROR: Failed to download $link" "Red"
            }
        } catch {
            Write-Color "ERROR: An unexpected error occurred while downloading $link" "Red"
        }
        Write-Color "------------------------------------------------------------" "Cyan"
    }
}

# Completion message
Write-Host ""
Write-Color "============================================================" "Cyan"
Write-Color "              All links processed. Script finished.         " "Green"
Write-Color "============================================================" "Cyan"
