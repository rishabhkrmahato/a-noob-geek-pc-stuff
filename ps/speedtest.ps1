# Write-Host "=========================================" -ForegroundColor Cyan
# Write-Host "              Speedtest CLI              " -ForegroundColor Green
# Write-Host "=========================================" -ForegroundColor Cyan

# Define variables
$systemDrive = $env:SystemDrive
$tempFolder = "$systemDrive\temp-rkm-tools"
$zipFile = "$tempFolder\speedtest.zip"
$extractedFolder = "$tempFolder\speedtest"
$speedtestExe = "$extractedFolder\speedtest.exe"
$downloadUrl = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"

# Create temporary directory if it doesn't exist
if (-not (Test-Path -Path $tempFolder)) {
    # Write-Host "[INFO] Creating temporary directory at $tempFolder..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
}

# Download Speedtest CLI
try {
    # Write-Host "[INFO] Downloading Speedtest CLI..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
    # Write-Host "[SUCCESS] Download completed!" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to download Speedtest CLI. Exiting..." -ForegroundColor Red
    exit 1
}

# Extract the ZIP file
try {
    # Write-Host "[INFO] Extracting Speedtest CLI..." -ForegroundColor Yellow
    Expand-Archive -Path $zipFile -DestinationPath $extractedFolder -Force
    # Write-Host "[SUCCESS] Extraction completed!" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to extract Speedtest CLI. Exiting..." -ForegroundColor Red
    exit 1
}

# Run Speedtest CLI with license auto-accept
# Write-Host "[INFO] Running Speedtest CLI... (License auto-accepted if running for the first time)" -ForegroundColor Yellow
try {
    Start-Process -FilePath $speedtestExe -ArgumentList "--accept-license" -NoNewWindow -Wait
    Write-Host ""
    Write-Host "[SUCCESS] Speedtest completed!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "[ERROR] Failed to execute Speedtest. Exiting..." -ForegroundColor Red
    exit 1
}

# Cleanup (Optional)
# Write-Host "[INFO] Cleaning up temporary files..." -ForegroundColor Yellow
try {
    Remove-Item -Path $zipFile -Force
    # Write-Host "[SUCCESS] Cleanup completed!" -ForegroundColor Green
} catch {
    # Write-Host "[WARNING] Failed to delete temporary files. Continuing..." -ForegroundColor DarkYellow
}

# Completion Message with Pause
# Write-Host "=========================================" -ForegroundColor Cyan
# Write-Host "      Speedtest CLI Execution Done       " -ForegroundColor Green
# Write-Host "=========================================" -ForegroundColor Cyan
# Write-Host "Press any key to exit..." -ForegroundColor Cyan
# [System.Console]::ReadKey($true) | Out-Null
