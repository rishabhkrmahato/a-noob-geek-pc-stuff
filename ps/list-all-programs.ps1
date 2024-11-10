# ps script to get every program/app/package/custom-shortcut/web-app/etc. from your every single corner of your windows and lists it, 
# change the paths accordingly.
# creates all-programs.csv file on user desktop.
# runs as admin for best resutls.

#Start-Transcript -Path "$env:UserProfile\Desktop\PowerShell_Log.txt" -Append
#uncomment line above(then move it to the top) and at the end, to verbose errors into a text file on desktop.

# Check if the script is running as Administrator
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $principal.IsInRole($adminRole)) {
    # If not running as admin, re-launch the script with admin rights
    $arguments = "& '" + $myinvocation.MyCommand.Definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Start-Sleep -Seconds 2
    Exit
}

# Define the output file
$outputFile = "$env:UserProfile\Desktop\all-programs.csv"

# Get installed applications from registry (32-bit and 64-bit)
$installedApps = Get-ItemProperty -Path `
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", `
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
    | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, InstallLocation

# Get installed Microsoft Store apps
$storeApps = Get-AppxPackage | Select-Object Name, PackageFullName, Version, Publisher

# Scan other common installation paths
$appPaths = @(
    "$env:UserProfile\AppData\Local\Programs",
    "$env:UserProfile\AppData\Local",
    "$env:ProgramFiles",
    "$env:ProgramFiles(x86)",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs",
    "$env:UserProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
)

$additionalApps = foreach ($path in $appPaths) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path -Directory | Select-Object Name, FullName
    }
}

# Process additional applications (non-standard installations)
$additionalAppsProcessed = $additionalApps | ForEach-Object {
    [PSCustomObject]@{
        DisplayName      = $_.Name
        DisplayVersion   = "Unknown"
        Publisher        = "Unknown"
        InstallLocation  = $_.FullName
        InstallDate      = "N/A"
    }
}

# Include custom Start Menu shortcuts (including Chrome web apps, if desired, removed here, i prefer firefox)
$customShortcutsPath1 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$customShortcutsPath2 = "$env:UserProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"

#to include custom chrome web apps; code below - commented out, but i don't use chrome anymore, firefox is far better.
#$customShortcutsPath3 = "$env:UserProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps"
#$customShortcuts = Get-ChildItem -Path $customShortcutsPath1, $customShortcutsPath2, $customShortcutsPath3 -Filter *.lnk |

$customShortcuts = Get-ChildItem -Path $customShortcutsPath1, $customShortcutsPath2 -Filter *.lnk | 
    Select-Object @{Name="DisplayName";Expression={$_.Name}}, 
    @{Name="InstallLocation";Expression={$_.FullName}}, 
    @{Name="DisplayVersion";Expression={"Custom Shortcut"}}, 
    @{Name="Publisher";Expression={"N/A"}}, 
    @{Name="InstallDate";Expression={"N/A"}}

# Combine all results
$allApps = $installedApps + $storeApps + $additionalAppsProcessed + $customShortcuts

# Export to CSV
$allApps | Export-Csv -Path $outputFile -NoTypeInformation

# Notify the user
Write-Host "Details saved to $outputFile"

#Stop-Transcript
#uncomment above line & and the one at top, for ps transcripting.