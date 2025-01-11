# ================================================================================================
# 
# Description:
# 
# System Event Counter and Report Generator
# 
# This PowerShell script analyzes the Windows System Event Log to count 
# and detail specific system events such as sleep, wake, shutdown, 
# fast shutdown, restart, and BSOD (Blue Screen of Death). The results 
# are summarized in the terminal and saved as a detailed report in a text file.
#
# Key Features:
# - Requires administrative privileges to access system logs.
# - Retrieves and counts specific event types using Event IDs:
#   - Sleep: Event ID 42
#   - Wake: Event ID 1
#   - Shutdown: Event ID 1074
#   - Fast Shutdown: Event ID 109
#   - Restart: Event ID 1074
#   - BSOD: Event ID 1001
# - Generates a detailed report with timestamps, IDs, and messages.
# - Provides a summary of event counts in the terminal.
#
# Usage:
# - Run this script as an administrator.
# - The detailed report will be saved to `%SystemDrive%\shut-sleep-wake-restart-bsod-counter.txt`.
#
# Dependencies:
# - Requires PowerShell 5.1 or later.
# - Administrative privileges to access system logs.
#
# Output:
# - Terminal: Displays a summary of the event counts.
# - File: Saves a detailed report of the events in a text file.
#
# Error Handling:
# - Exits with a message if the script is not run with administrative privileges.
# ================================================================================================

# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrative privileges." -ForegroundColor Red
    Write-Host "Right-click the script and select 'Run as administrator' to proceed." -ForegroundColor Yellow
    Write-Host ""
    exit
}

# Check PowerShell Version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "This script requires PowerShell 5.1 or later. Please upgrade your PowerShell version." -ForegroundColor Red
    exit
}

# Define File Path for Output
$SystemDrive = [System.Environment]::GetEnvironmentVariable("SystemDrive")
$OutputFile = [IO.Path]::Combine("$SystemDrive\", "shut-sleep-wake-restart-bsod-counter.txt")

# Define Event IDs for Specific Events
$EventIDs = @{
    "Sleep" = 42
    "Wake" = 1
    "Shutdown" = 1074
    "FastShutdown" = 109
    "Restart" = 1074
    "BSOD" = 1001
}

# Function to Retrieve Events
function Get-SystemEvents {
    param (
        [int[]]$EventID
    )
    Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        ID = $EventID
    }
}

# Retrieve Events
$SleepEvents = Get-SystemEvents -EventID $EventIDs["Sleep"]
$WakeEvents = Get-SystemEvents -EventID $EventIDs["Wake"]
$ShutdownEvents = Get-SystemEvents -EventID $EventIDs["Shutdown"]
$FastShutdownEvents = Get-SystemEvents -EventID $EventIDs["FastShutdown"]
$RestartEvents = Get-SystemEvents -EventID $EventIDs["Restart"]
$BSODEvents = Get-SystemEvents -EventID $EventIDs["BSOD"]

# Count Events
$EventCounts = @{
    "Sleep" = $SleepEvents.Count
    "Wake" = $WakeEvents.Count
    "Shutdown" = $ShutdownEvents.Count
    "Fast Shutdown" = $FastShutdownEvents.Count
    "Restart" = $RestartEvents.Count
    "BSOD" = $BSODEvents.Count
}

# Write Detailed Results to File with Error Handling
try {
    "========= Detailed System Events Report =========" | Out-File -FilePath $OutputFile
    "Generated on: $(Get-Date)" | Out-File -FilePath $OutputFile -Append
    "-------------------------------------------------" | Out-File -FilePath $OutputFile -Append

    function Write-EventDetailsToFile {
        param (
            [string]$Title,
            [array]$Events
        )
        $TitleLine = "========== $Title =========="
        $TitleLine | Out-File -FilePath $OutputFile -Append
        if ($Events.Count -eq 0) {
            "No $Title events found." | Out-File -FilePath $OutputFile -Append
        } else {
            foreach ($Event in $Events) {
                "Time: $($Event.TimeCreated)" | Out-File -FilePath $OutputFile -Append
                "ID: $($Event.ID)" | Out-File -FilePath $OutputFile -Append
                "Message: $($Event.Message)" | Out-File -FilePath $OutputFile -Append
                "------------------------------------" | Out-File -FilePath $OutputFile -Append
            }
        }
    }

    Write-EventDetailsToFile -Title "Sleep Events" -Events $SleepEvents
    Write-EventDetailsToFile -Title "Wake Events" -Events $WakeEvents
    Write-EventDetailsToFile -Title "Shutdown Events" -Events $ShutdownEvents
    Write-EventDetailsToFile -Title "Fast Shutdown Events" -Events $FastShutdownEvents
    Write-EventDetailsToFile -Title "Restart Events" -Events $RestartEvents
    Write-EventDetailsToFile -Title "BSOD Events" -Events $BSODEvents

    "-------------------------------------------------" | Out-File -FilePath $OutputFile -Append
    "End of Report" | Out-File -FilePath $OutputFile -Append

} catch {
    Write-Host "An error occurred while writing to the file: $OutputFile" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit
}

# # Display Summary in Terminal with no alignments (results not looking good)
# Write-Host "=============================================" -ForegroundColor Cyan
# Write-Host "Summary of Events:" -ForegroundColor Cyan
# Write-Host ""
# foreach ($Key in $EventCounts.Keys) {
#     Write-Host "$Key --- $($EventCounts[$Key])" -ForegroundColor Green
# }
# Write-Host "=============================================" -ForegroundColor Cyan

# Define the Desired Order for Output
$DesiredOrder = @("Sleep", "Wake", "Shutdown", "Restart", "Fast Shutdown", "BSOD")

# Display Summary in Terminal with Proper Alignment
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Summary of Events:" -ForegroundColor Magenta
Write-Host ""

# Calculate the maximum length of the event names for alignment
$maxKeyLength = ($EventCounts.Keys | ForEach-Object { $_.Length }) | Measure-Object -Maximum
$maxKeyLength = $maxKeyLength.Maximum

# Format and display each line in the desired order
foreach ($Key in $DesiredOrder) {
    if ($EventCounts.ContainsKey($Key)) {
        $paddedKey = $Key.PadRight($maxKeyLength)  # Pad event names to align
        Write-Host "$paddedKey --- $($EventCounts[$Key])" -ForegroundColor Green
    }
}
Write-Host "=============================================" -ForegroundColor Cyan

# Inform User of Report Location
Write-Host ""
Write-Host "Detailed report saved to $OutputFile" -ForegroundColor Magenta
Write-Host ""
