# valorant-permablock.ps1
# ASCII-clean, robust, production-ready.
# Run this script as Administrator.

# Admin check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output ""
    Write-Output "ERROR: Run this script as Administrator."
    Write-Output "Open PowerShell as Administrator and re-run this script."
    exit 1
}

# Logging helpers
function Info($m) { Write-Output ("[INFO]  {0} - {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $m) }
function Ok($m)   { Write-Output ("[ OK ]  {0} - {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $m) }
function Warn($m) { Write-Output ("[WARN]  {0} - {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $m) }

# Banner
Write-Output ""
Write-Output "============================================================="
Write-Output "IMPORTANT - Please uninstall VALORANT first using Revo Uninstaller"
Write-Output "1) Open Revo Uninstaller."
Write-Output "2) Uninstall VALORANT and RIOT/VANGUARD."
Write-Output "3) Use Advanced/Deep scan to remove leftovers."
Write-Output "4) After Revo finishes, run this script as Administrator."
Write-Output "============================================================="
Write-Output ""

Info "RiotBlock: starting setup."

# Paths and workspace
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$backupDir = Join-Path $env:ProgramData "RiotBlock\backups"
$workDir   = Join-Path $env:ProgramData "RiotBlock"
New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
New-Item -Path $workDir -ItemType Directory -Force | Out-Null

# Backup hosts (best-effort)
Info "Backing up hosts file..."
try {
    $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $hostsBackup = Join-Path $backupDir ("hosts.bak." + $timestamp)
    Copy-Item -Path $hostsPath -Destination $hostsBackup -Force -ErrorAction Stop
    Ok ("Hosts backed up to: " + $hostsBackup)
} catch {
    Warn "Backup failed (hosts missing or access denied). Continuing..."
}

# Hostnames to block
$riotHosts = @(
"riotgames.com",
"playvalorant.com",
"auth.riotgames.com",
"valorant.secure.dyn.riotcdn.net",
"update.valorant.secure.dyn.riotcdn.net",
"cdnvalorant-a.akamaihd.net",
"riotcdn.net",
"riotgames-a.akamaihd.com",
"cdn.riotgames.com"
)

# Function: schedule a retry at next boot if hosts is locked
function Register-HostsFix {
    param($workDir, $riotHosts)

    $fixScript = Join-Path $workDir "fix-hosts-at-startup.ps1"

    # Build the helper script as literal lines to avoid nested quoting problems
    $scriptLines = @()
    $scriptLines += "# fix-hosts-at-startup.ps1"
    $scriptLines += "# Attempts to add Riot/Valorant entries to hosts (runs at system startup)"
    $scriptLines += '$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"'
    $scriptLines += '$riotHostsLocal = @('
    foreach ($h in $riotHosts) { $scriptLines += "    '$h'" }
    $scriptLines += ')'
    $scriptLines += 'try {'
    $scriptLines += '    $hostsContent = Get-Content -Path $hostsPath -ErrorAction SilentlyContinue'
    $scriptLines += '    if (-not $hostsContent) { $hostsContent = @() }'
    $scriptLines += '    foreach ($h in $riotHostsLocal) {'
    $scriptLines += '        $pattern = "^\s*127\.0\.0\.1\s+$([regex]::Escape($h))\s*$"'
    $scriptLines += '        if (-not ($hostsContent -match $pattern)) {'
    $scriptLines += '            Add-Content -Path $hostsPath -Value ("127.0.0.1`t" + $h) -Encoding ASCII -ErrorAction SilentlyContinue'
    $scriptLines += '        }'
    $scriptLines += '    }'
    $scriptLines += '} catch { }'

    # Write helper script (ASCII)
    Set-Content -Path $fixScript -Value $scriptLines -Encoding ASCII -Force

    # Register scheduled task to run at startup (SYSTEM)
    $taskName = "RiotBlock-FixHostsAtStartup"
    try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue } catch { }
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$fixScript`""
    $trigger = New-ScheduledTaskTrigger -AtStartup
    try {
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Description "Retry hosts update for RiotBlock" -User "SYSTEM"
        Ok "Hosts update scheduled at system startup (will retry if hosts locked)."
    } catch {
        Warn "Could not schedule hosts fix task. You may need to update hosts manually."
    }
}

# Attempt to append hosts entries (idempotent)
Info "Attempting to add Riot/Valorant host entries (idempotent)..."
try {
    $hostsContent = Get-Content -Path $hostsPath -ErrorAction SilentlyContinue
    if (-not $hostsContent) { $hostsContent = @() }
    $toAdd = @()
    foreach ($h in $riotHosts) {
        $pattern = "^\s*127\.0\.0\.1\s+$([regex]::Escape($h))\s*$"
        if (-not ($hostsContent -match $pattern)) { $toAdd += ("127.0.0.1`t" + $h) }
    }

    if ($toAdd.Count -gt 0) {
        try {
            Add-Content -Path $hostsPath -Value $toAdd -Encoding ASCII -ErrorAction Stop
            Ok "Hosts updated (entries added)."
        } catch {
            Warn "Hosts file is locked by another process. Will schedule a retry at next startup."
            Register-HostsFix -workDir $workDir -riotHosts $riotHosts
        }
    } else {
        Ok "Hosts already contain Riot/Valorant entries (no change)."
    }
} catch {
    Warn "Unexpected error while checking/updating hosts. A retry is scheduled."
    Register-HostsFix -workDir $workDir -riotHosts $riotHosts
}

# Stop and delete Vanguard services (best-effort)
Info "Stopping and deleting Vanguard services (vgc, vgk) if present..."
$svcNames = @("vgc","vgk")
foreach ($svc in $svcNames) {
    try {
        $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($s) {
            if ($s.Status -ne 'Stopped') { Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue }
            sc.exe delete $svc | Out-Null
            Ok ("Service '" + $svc + "' stop/delete requested.")
        } else {
            sc.exe delete $svc 2>$null | Out-Null
            Info ("Service '" + $svc + "' not found; attempted delete.")
        }
    } catch {
        Warn ("Could not remove service: " + $svc)
    }
}

# Remove known Riot / Vanguard folders
Info "Removing common Riot/Vanguard folders if present..."
$pathsToRemove = @()
$pathsToRemove += Join-Path $env:ProgramFiles "Riot Games"
$pathsToRemove += Join-Path $env:ProgramFiles "Riot Vanguard"
if (${env:ProgramFiles(x86)}) {
    $pathsToRemove += Join-Path ${env:ProgramFiles(x86)} "Riot Games"
    $pathsToRemove += Join-Path ${env:ProgramFiles(x86)} "Riot Vanguard"
}
$pathsToRemove += Join-Path $env:ProgramData "Riot Games"
$pathsToRemove += Join-Path $env:ProgramData "Riot Vanguard"
$pathsToRemove += Join-Path $env:LOCALAPPDATA "Riot Games"
$pathsToRemove += Join-Path $env:LOCALAPPDATA "Riot Vanguard"

foreach ($p in $pathsToRemove) {
    if ($p -and (Test-Path $p)) {
        try {
            Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction SilentlyContinue
            Ok ("Removed: " + $p)
        } catch {
            Warn ("Failed to remove: " + $p)
        }
    } else {
        Info ("Not present: " + $p)
    }
}

# Firewall rules
Info "Creating outbound firewall rules..."
$rules = @()
$rules += @{ Name="Block_VALORANT_exe"; Program=Join-Path $env:ProgramFiles "Riot Games\VALORANT\live\VALORANT.exe" }
$rules += @{ Name="Block_RiotClientServices"; Program=Join-Path $env:ProgramFiles "Riot Games\Riot Client\RiotClientServices.exe" }
if (${env:ProgramFiles(x86)}) {
    $rules += @{ Name="Block_RiotClientServices_x86"; Program=Join-Path ${env:ProgramFiles(x86)} "Riot Games\Riot Client\RiotClientServices.exe" }
    $rules += @{ Name="Block_VALORANT_live_x86"; Program=Join-Path ${env:ProgramFiles(x86)} "Riot Games\VALORANT\live\VALORANT.exe" }
}
$rules += @{ Name="Block_RiotVanguard_vgc"; Program=Join-Path $env:ProgramFiles "Riot Vanguard\vgc.exe" }
$rules += @{ Name="Block_RiotVanguard_vgtray"; Program=Join-Path $env:ProgramFiles "Riot Vanguard\vgtray.exe" }

foreach ($r in $rules) {
    try { Get-NetFirewallRule -DisplayName $r.Name -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue } catch { }
    try {
        New-NetFirewallRule -DisplayName $r.Name -Direction Outbound -Program $r.Program -Action Block -Profile Any -Enabled True -EdgeTraversalPolicy Block -ErrorAction SilentlyContinue
        Ok ("Created rule: " + $r.Name)
    } catch {
        Warn ("Could not create firewall rule: " + $($r.Name))
    }
}

# Maintenance scripts
Info "Installing maintenance scripts..."
$cleanupDownloadScript = Join-Path $workDir "cleanup-downloads.ps1"
$cleanupSystemScript   = Join-Path $workDir "cleanup-system.ps1"

$cleanupDownloadContent = @'
# cleanup-downloads.ps1
try {
    $dl = Join-Path $env:USERPROFILE 'Downloads'
    Get-ChildItem -Path $dl -Recurse -Force -ErrorAction SilentlyContinue |
      Where-Object { -not $_.PSIsContainer -and ($_.Name -match "(?i)riot" -or $_.Name -match "(?i)valorant") } |
      ForEach-Object { Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue }
} catch { }
'@

$cleanupSystemContent = @'
# cleanup-system.ps1
try {
    sc.exe stop vgc 2>$null
    sc.exe stop vgk 2>$null
    sc.exe delete vgc 2>$null
    sc.exe delete vgk 2>$null
    $paths = @(
        Join-Path $env:ProgramFiles 'Riot Games',
        Join-Path $env:ProgramFiles 'Riot Vanguard'
    )
    if (${env:ProgramFiles(x86)}) {
        $paths += Join-Path ${env:ProgramFiles(x86)} 'Riot Games'
        $paths += Join-Path ${env:ProgramFiles(x86)} 'Riot Vanguard'
    }
    $paths += Join-Path $env:ProgramData 'Riot Games'
    $paths += Join-Path $env:ProgramData 'Riot Vanguard'
    $paths += Join-Path $env:LOCALAPPDATA 'Riot Games'
    $paths += Join-Path $env:LOCALAPPDATA 'Riot Vanguard'
    foreach ($p in $paths) {
        if (Test-Path $p) {
            Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
} catch { }
'@

Set-Content -Path $cleanupDownloadScript -Value $cleanupDownloadContent -Force -Encoding ASCII
Set-Content -Path $cleanupSystemScript -Value $cleanupSystemContent -Force -Encoding ASCII
Ok ("Maintenance scripts created at: " + $workDir)

# Scheduled tasks
Info "Registering scheduled tasks..."
try {
    $taskName1 = "RiotBlock-CleanupDownloads"
    $taskName2 = "RiotBlock-CleanupSystem"
    Unregister-ScheduledTask -TaskName $taskName1 -Confirm:$false -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName $taskName2 -Confirm:$false -ErrorAction SilentlyContinue

    $action1 = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$cleanupDownloadScript`""
    $trigger1 = New-ScheduledTaskTrigger -Daily -At 3am
    Register-ScheduledTask -TaskName $taskName1 -Action $action1 -Trigger $trigger1 -RunLevel Highest -Description "Remove downloaded riot/valorant files" -User "SYSTEM"
    Ok ("Registered scheduled task: " + $taskName1 + " (Daily 03:00)")

    $action2 = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$cleanupSystemScript`""
    $trigger2 = New-ScheduledTaskTrigger -AtLogOn
    Register-ScheduledTask -TaskName $taskName2 -Action $action2 -Trigger $trigger2 -RunLevel Highest -Description "Remove Riot folders and stop/delete Vanguard" -User "SYSTEM"
    Ok ("Registered scheduled task: " + $taskName2 + " (At logon)")
} catch {
    Warn "Failed to register scheduled tasks. Check Task Scheduler and ensure script ran elevated."
}

# Make hosts read-only
Info "Setting hosts file to read-only (adds friction)..."
try {
    (Get-Item -LiteralPath $hostsPath).IsReadOnly = $true
    Ok "hosts file set to read-only."
} catch {
    Warn "Could not set hosts read-only (permission or file missing)."
}

# IFEO block
Info "Adding IFEO entries to block common Riot/Valorant executables..."
$exeList = @("VALORANT.exe","RiotClientServices.exe","RiotClientUx.exe","vgc.exe","vgtray.exe","RiotClientCrashHandler.exe")
$ifeoBase = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
foreach ($exe in $exeList) {
    try {
        $keyPath = Join-Path $ifeoBase $exe
        if (-not (Test-Path $keyPath)) { New-Item -Path $keyPath -Force | Out-Null }
        New-ItemProperty -Path $keyPath -Name "Debugger" -Value "$env:windir\System32\cmd.exe" -PropertyType String -Force | Out-Null
        Ok ("IFEO applied: " + $exe)
    } catch {
        Warn ("IFEO failed for: " + $exe)
    }
}

# Final summary
Write-Output ""
Write-Output "============================================================="
Ok "RiotBlock: Setup complete."
Info ("Hosts backup: " + $hostsBackup)
Info ("Maintenance scripts and scheduled tasks: " + $workDir)
Info ("IFEO entries added for: " + ($exeList -join ", "))
Info ("Firewall rules created: " + (($rules | ForEach-Object { $_.Name }) -join ", "))
Write-Output "============================================================="
Write-Output ""
Warn "REMINDER: You are full admin. Protections add friction but are reversible by you."
Info ("RiotBlock finished at: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
