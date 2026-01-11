# ================================
# FULL VALORANT SYSTEM RESTORE
# ================================

Write-Host "Starting FULL Valorant system restore..."

# 1. Remove IFEO hijacks
$ifeo = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
$exeList = @("VALORANT.exe","RiotClientServices.exe","RiotClientUx.exe","vgc.exe","vgtray.exe","RiotClientCrashHandler.exe")

foreach ($exe in $exeList) {
    $key = Join-Path $ifeo $exe
    if (Test-Path $key) {
        Remove-Item -Path $key -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Removed IFEO hijack: $exe"
    }
}

# 2. Remove scheduled tasks
$tasks = @("RiotBlock-CleanupDownloads","RiotBlock-CleanupSystem","RiotBlock-FixHostsAtStartup")
foreach ($t in $tasks) {
    Unregister-ScheduledTask -TaskName $t -Confirm:$false -ErrorAction SilentlyContinue
}

# 3. Remove firewall blocks
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "Block_*"} | Remove-NetFirewallRule -ErrorAction SilentlyContinue

# 4. Restore hosts file
$hosts = "$env:SystemRoot\System32\drivers\etc\hosts"
attrib -r -s -h $hosts 2>$null
Set-Content $hosts "127.0.0.1 localhost" -Force -Encoding ASCII

# 5. Remove RiotBlock workspace
Remove-Item "C:\ProgramData\RiotBlock" -Recurse -Force -ErrorAction SilentlyContinue

# 6. Reset Winsock + DNS
ipconfig /flushdns | Out-Null
netsh winsock reset | Out-Null

Write-Host ""
Write-Host "SYSTEM RESTORE COMPLETE."
Write-Host "Restart your PC now."
pause
