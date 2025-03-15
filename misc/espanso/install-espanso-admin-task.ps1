# ==========================================================================================================================
# 📌Espanso Task Import & Start (PowerShell)
# - This script **downloads and imports a scheduled task** (`espanso-admin`)
#   from **GitHub** and optionally **starts it**.
# - Requires **Administrator privileges** for scheduled task management.
# ✅ **What This Script Does:**
# 1️⃣ **Checks & Requests Admin Privileges** if not running as admin.
# 2️⃣ **Downloads the scheduled task XML file** from:
#    🔗 `https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/raw/main/misc/espanso/espanso-admin.xml`
# 3️⃣ **Imports the task into Windows Task Scheduler** (`schtasks`).
# 4️⃣ **Asks the user if they want to start the task immediately**.
# 🚀 **Usage:**
# - **Run this script as Admin** to create the task.
# - The script will ask if you want to start the task after importing.
# ⚠️ **Caution:**
# - Ensure `schtasks` is **available** (`Get-Command schtasks`).
# - The **XML file must exist on GitHub** to be downloaded properly.
# ==========================================================================================================================


# Check if running as admin, if not, restart as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Requesting admin privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Define variables
$taskUrl = "https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/raw/main/misc/espanso/espanso-admin.xml"
$downloadPath = "$env:USERPROFILE\Downloads\espanso-admin.xml"
$taskName = "espanso-admin"

# Download the XML file
Write-Host "Downloading task XML file..."
Invoke-WebRequest -Uri $taskUrl -OutFile $downloadPath

# Import the task
Write-Host "Importing task..."
schtasks /create /xml "$downloadPath" /tn "$taskName" /f

# Confirm import
Write-Host "`nTask imported successfully!"
$startTask = Read-Host "Do you want to start the task now? (Y/N)"

# Start the task if user agrees
if ($startTask -match "^[Yy]$") {
    schtasks /run /tn "$taskName"
    Write-Host "Task started successfully!"
} else {
    Write-Host "Task was not started."
}

# Exit
Start-Sleep -Seconds 2
exit
