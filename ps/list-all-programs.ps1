# Uncomment the lines below (& one at the end-of-file) to enable verbose logging to a file
# Start-Transcript -Path "$env:UserProfile\Desktop\PowerShell_Log.txt" -Append

# Check if the script is running as Administrator
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $principal.IsInRole($adminRole)) {
    Write-Host -ForegroundColor Yellow "Script is not running with Administrator privileges. Restarting as Admin..."
    $arguments = "& '" + $myinvocation.MyCommand.Definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Start-Sleep -Seconds 2
    Exit
}

# Define the output file path
$outputFile = "$env:UserProfile\Desktop\all-programs.csv"

# ------------------------------
# SECTION: Installed Applications
# ------------------------------
Write-Host -ForegroundColor Cyan "Fetching installed applications from the Registry..."

try {
    $installedApps = Get-ItemProperty -Path `
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", `
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", `
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
        | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, InstallLocation

    # Validate the result
    if (-not $installedApps) {
        Write-Host -ForegroundColor Yellow "No installed applications found in the registry."
        $installedApps = @()
    }
} catch {
    Write-Host -ForegroundColor Red "Error fetching installed applications: $_"
}

# ------------------------------
# SECTION: Microsoft Store Apps
# ------------------------------
Write-Host -ForegroundColor Cyan "Fetching Microsoft Store apps..."

try {
    $storeApps = Get-AppxPackage | Select-Object Name, PackageFullName, Version, Publisher
} catch {
    Write-Host -ForegroundColor Red "Error fetching Microsoft Store apps: $_"
    $storeApps = @() # Initialize to empty array if error occurs
}

# ------------------------------
# SECTION: Additional App Paths
# ------------------------------
Write-Host -ForegroundColor Cyan "Scanning additional common installation paths..."

$appPaths = @(
    "$env:UserProfile\AppData\Local\Programs",
    "$env:UserProfile\AppData\Local",
    "$env:ProgramFiles",
    "$env:ProgramFiles(x86)",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs",
    "$env:UserProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
)

try {
    $additionalApps = foreach ($path in $appPaths) {
        if (Test-Path $path) {
            Get-ChildItem -Path $path -Directory | Select-Object Name, FullName
        }
    }

    $additionalAppsProcessed = $additionalApps | ForEach-Object {
        [PSCustomObject]@{
            DisplayName      = $_.Name
            DisplayVersion   = "Unknown"
            Publisher        = "Unknown"
            InstallLocation  = $_.FullName
            InstallDate      = "N/A"
        }
    }

    # Validate result
    if (-not $additionalAppsProcessed) {
        Write-Host -ForegroundColor Yellow "No additional applications found in specified paths."
        $additionalAppsProcessed = @()
    }
} catch {
    Write-Host -ForegroundColor Red "Error scanning additional paths: $_"
    $additionalAppsProcessed = @()
}

# ------------------------------
# SECTION: Custom Shortcuts (Including Chrome Web Apps)
# ------------------------------
Write-Host -ForegroundColor Cyan "Including custom Start Menu shortcuts and Chrome web apps..."

$customShortcutsPath1 = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$customShortcutsPath2 = "$env:UserProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
$customShortcutsPath3 = "$env:UserProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps"

try {
    $customShortcuts = Get-ChildItem -Path $customShortcutsPath1, $customShortcutsPath2, $customShortcutsPath3 -Filter *.lnk |
        Select-Object @{Name="DisplayName";Expression={$_.Name}}, 
                      @{Name="InstallLocation";Expression={$_.FullName}}, 
                      @{Name="DisplayVersion";Expression={"Custom Shortcut"}}, 
                      @{Name="Publisher";Expression={"N/A"}}, 
                      @{Name="InstallDate";Expression={"N/A"}}
} catch {
    Write-Host -ForegroundColor Red "Error fetching custom shortcuts: $_"
    $customShortcuts = @()
}

# ------------------------------
# SECTION: Package Manager Programs
# ------------------------------
Write-Host -ForegroundColor Cyan "Fetching programs installed via popular package managers..."

$packageManagerApps = @()

# Chocolatey Programs
try {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Yellow "Fetching Chocolatey packages..."
        $chocoPackages = choco list --localonly | ForEach-Object {
            [PSCustomObject]@{
                DisplayName      = $_ -replace "(\s{2,}.*)", ""
                DisplayVersion   = "N/A"
                Publisher        = "Chocolatey"
                InstallLocation  = "N/A"
                InstallDate      = "N/A"
            }
        }
        $packageManagerApps += $chocoPackages
    } else {
        Write-Host -ForegroundColor Gray "Chocolatey is not installed or not found."
    }
} catch {
    Write-Host -ForegroundColor Red "Error fetching Chocolatey packages: $_"
}

# Scoop Programs
try {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Yellow "Fetching Scoop packages..."
        $scoopPackages = scoop list | ForEach-Object { 
        # $scoopPackages = scoop list | Where-Object { $_ -notmatch "Installed apps:" } | ForEach-Object {
            [PSCustomObject]@{
                DisplayName      = $_.Name
                DisplayVersion   = "N/A"
                Publisher        = "Scoop"
                InstallLocation  = $_.InstallLocation
                InstallDate      = "N/A"
            }
        }        
        $packageManagerApps += $scoopPackages
    } else {
        Write-Host -ForegroundColor Gray "Scoop is not installed or not found."
    }
} catch {
    Write-Host -ForegroundColor Red "Error fetching Scoop packages: $_"
}

# npm Global Packages
try {
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Yellow "Fetching npm global packages..."
        $npmPackages = npm list -g --depth=0 | ForEach-Object {
            [PSCustomObject]@{
                DisplayName      = $_.Name
                DisplayVersion   = "N/A"
                Publisher        = "npm"
                InstallLocation  = "N/A"
                InstallDate      = "N/A"
            }
        }
        $packageManagerApps += $npmPackages
    } else {
        Write-Host -ForegroundColor Gray "npm is not installed or not found."
    }
} catch {
    Write-Host -ForegroundColor Red "Error fetching npm packages: $_"
}

# pip Global Packages
try {
    if (Get-Command pip -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Yellow "Fetching pip global packages..."
        $pipPackages = pip list --format=freeze | ForEach-Object {
            [PSCustomObject]@{
                DisplayName      = ($_ -split "==")[0]
                DisplayVersion   = ($_ -split "==")[1]
                Publisher        = "pip"
                InstallLocation  = "N/A"
                InstallDate      = "N/A"
            }
        }
        $packageManagerApps += $pipPackages
    } else {
        Write-Host -ForegroundColor Gray "pip is not installed or not found."
    }
} catch {
    Write-Host -ForegroundColor Red "Error fetching pip packages: $_"
}

# Python Scripts and Executables
try {
    Write-Host -ForegroundColor Yellow "Searching for Python installed scripts..."
    $pythonScripts = Get-ChildItem -Path "$env:UserProfile\AppData\Local\Programs\Python" -Recurse -Filter *.exe | ForEach-Object {
        [PSCustomObject]@{
            DisplayName      = $_.Name
            DisplayVersion   = "N/A"
            Publisher        = "Python"
            InstallLocation  = $_.FullName
            InstallDate      = "N/A"
        }
    }
    $packageManagerApps += $pythonScripts
} catch {
    Write-Host -ForegroundColor Red "Error fetching Python scripts: $_"
}

# ------------------------------
# SECTION: Combine Results
# ------------------------------
Write-Host -ForegroundColor Cyan "Combining all application data..."

try {
    # Combine all collected applications and packages
    $allApps = $installedApps + $storeApps + $additionalAppsProcessed + $customShortcuts + $packageManagerApps

    # Check if no data was collected
    if (-not $allApps) {
        Write-Host -ForegroundColor Yellow "No application data found. CSV file will not be created."
        Exit
    }

    # Export results to CSV (Overwrites existing file by default)
    $allApps | Export-Csv -Path $outputFile -NoTypeInformation

    Write-Host ""
    Write-Host -ForegroundColor Green "Details successfully saved to $outputFile"
} catch {
    Write-Host -ForegroundColor Red "Error combining or exporting results: $_"
}

# Pause to prevent terminal from closing
Write-Host -ForegroundColor Yellow "Press any key to exit..."
Read-Host

# Uncomment the line below to end verbose logging
# Stop-Transcript
