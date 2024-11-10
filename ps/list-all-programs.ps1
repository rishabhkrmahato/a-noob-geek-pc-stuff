# powershell script to get all apps+softwares+custom-start-menu-shortcuts+chrome-web-apps list from your pc, change the paths accordingly
# creates Installed_Apps.csv file on user desktop
# runs as admin for best resutls

# Check if the script is running as Administrator
$runAsAdmin = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not ($runAsAdmin.Groups -contains (New-Object System.Security.Principal.SecurityIdentifier($adminRole)))) {
    # If not running as admin, re-launch the script with admin rights
    $arguments = "& '" + $myinvocation.MyCommand.Definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Start-Sleep -Seconds 2
    Exit
}

# Define the output file
$outputFile = "$env:UserProfile\Desktop\Installed_Apps.csv"

# Get installed applications from registry (32-bit and 64-bit)
$installedApps = Get-ItemProperty -Path `
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", `
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", `
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
    | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, InstallLocation
    

# Get installed Microsoft Store apps
$storeApps = Get-AppxPackage | Select-Object Name, PackageFullName, Version, Publisher


# Combine results
$allApps = $installedApps + $storeApps


# Include custom batch script shortcuts
$customShortcutsPath1 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$customShortcutsPath2 = "C:\Users\mahat\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
#to include custom chrome web apps, but i don't use chrome anymore, firefox is far better.
#$customShortcutsPath3 = "C:\Users\mahat\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps"
#$customShortcuts = Get-ChildItem -Path $customShortcutsPath1, $customShortcutsPath2, $customShortcutsPath3 -Filter *.lnk | 
$customShortcuts = Get-ChildItem -Path $customShortcutsPath1, $customShortcutsPath2 -Filter *.lnk | 
    Select-Object Name, FullName
    
# Add custom shortcuts to the result
$allApps += $customShortcuts | Select-Object @{Name="DisplayName";Expression={$_.Name}}, 
    @{Name="InstallLocation";Expression={$_.FullName}}, 
    @{Name="DisplayVersion";Expression={"Custom Shortcut"}}, 
    @{Name="Publisher";Expression={"N/A"}}, 
    @{Name="InstallDate";Expression={"N/A"}}
    

# Export to CSV
$allApps | Export-Csv -Path $outputFile -NoTypeInformation


# Notify the user
Write-Host "Details saved to $outputFile"
