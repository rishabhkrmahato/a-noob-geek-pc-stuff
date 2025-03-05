# ================================================================================================
# Description:
# System Event Counter (Shutdown/Sleep/BSOD...)
# 
# This script retrieves system event logs for shutdown, sleep, wake, restart,
# and blue screen (BSOD) events. It generates a summary and saves detailed 
# event logs to a text file.
#
# Key Features:
# - Requires administrative privileges to access system event logs.
# - Checks for PowerShell version 5.1+ before running.
# - Retrieves specific event logs (Shutdown, Sleep, Wake, Restart, BSOD).
# - Displays a summary in the terminal with aligned formatting.
# - Saves a detailed event report to a file.
#
# Hard-Coded Details:
# - `OutputFile = "$env:SystemDrive\shut-sleep-wake-restart-bsod-counter.txt"`
# - Retrieves logs from the Windows 'System' event log.
#
# Steps to Update Hard-Coded Details:
# 1. Modify `$OutputFile` to change the report storage location.
# 2. Adjust `$EventIDs` if additional system events need to be tracked.
#
# Usage:
# - Run the script as an administrator.
# - The event summary is displayed in the terminal.
# - A detailed event log is saved to a text file.
#
# Dependencies:
# - Windows Event Viewer (`Get-WinEvent` is used to fetch logs).
#
# Output:
# - Summary of event counts displayed in the terminal.
# - Detailed event log stored in `shut-sleep-wake-restart-bsod-counter.txt`.
#
# Error Handling:
# - Displays an error if the script is not run with administrative privileges.
# - Handles cases where logs may be cleared or inaccessible.
#
# Notes:
# - If event logs are cleared, the script may show zero counts.
# ================================================================================================


if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrative privileges." -ForegroundColor Red
    Write-Host "Right-click the script and select 'Run as administrator' to proceed." -ForegroundColor Yellow
    exit
}

# Check PowerShell Version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "This script requires PowerShell 5.1 or later. Please upgrade your PowerShell version." -ForegroundColor Red
    exit
}

# Define File Path for Output
$OutputFile = "$env:SystemDrive\shut-sleep-wake-restart-bsod-counter.txt"

# Define Event IDs for Specific Events
$EventIDs = @{
    "Sleep" = 42
    "Wake" = 1
    "Shutdown" = 1074
    "Fast Shutdown" = 109
    "Restart" = 1074
    "BSOD" = 1001
}

# Function to Retrieve Events with Error Handling
function Get-SystemEvents {
    param ([int[]]$EventID)
    try {
        $events = Get-WinEvent -FilterHashtable @{ LogName = 'System'; ID = $EventID } -ErrorAction SilentlyContinue
        return $events
    } catch {
        return @()  # Return empty array on failure
    }
}

# Retrieve Events
$EventData = @{}
foreach ($key in $EventIDs.Keys) {
    $EventData[$key] = Get-SystemEvents -EventID $EventIDs[$key]
}

# Count Events
$EventCounts = @{}
foreach ($key in $EventData.Keys) {
    $EventCounts[$key] = $EventData[$key].Count
}

# Write Detailed Results to File with Error Handling
try {
    @"
========= Detailed System Events Report =========
Generated on: $(Get-Date)
-------------------------------------------------
"@ | Out-File -FilePath $OutputFile

    function Write-EventDetailsToFile {
        param ([string]$Title, [array]$Events)
        "`n========== $Title ==========" | Out-File -FilePath $OutputFile -Append
        if ($Events.Count -eq 0) {
            "No $Title events found. (Logs may have been cleared)" | Out-File -FilePath $OutputFile -Append
        } else {
            foreach ($Event in $Events) {
                @"
Time: $($Event.TimeCreated)
ID: $($Event.ID)
Message: $($Event.Message)
------------------------------------
"@ | Out-File -FilePath $OutputFile -Append
            }
        }
    }

    # Write all event categories
    foreach ($key in $EventData.Keys) {
        Write-EventDetailsToFile -Title $key -Events $EventData[$key]
    }

    "`n-------------------------------------------------" | Out-File -FilePath $OutputFile -Append
    "End of Report" | Out-File -FilePath $OutputFile -Append

} catch {
    Write-Host "An error occurred while writing to the file: $OutputFile" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit
}

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
        $eventCount = $EventCounts[$Key]
        $message = if ($eventCount -eq 0) { "No events found.(Logs may have been cleared)" } else { "$eventCount" }
        Write-Host "$paddedKey --- $message" -ForegroundColor Green
    }
}
Write-Host "=============================================" -ForegroundColor Cyan

# Inform User of Report Location
Write-Host ""
Write-Host "Detailed report saved to $OutputFile" -ForegroundColor Magenta
Write-Host ""
