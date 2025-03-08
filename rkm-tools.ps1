<#
.SYNOPSIS
rkm-Tools: These are personal tools I’ve created and use regularly on my PC ❤️.

.DESCRIPTION
https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/blob/main/README.md

.AUTHOR
Rishabh Kumar Mahato (Sonu)
https://rishabhkrmahato.github.io/a-noob-geek-pc-stuff/

.VERSION
1.0.0

.LINK
GitHub Repository: https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff

.NOTES
- *** Always run this script with administrative privileges for optimal functionality. ***
- Ensure you have an active internet connection to fetch and run remote scripts.
#>

# $Host.UI.RawUI.BackgroundColor = 'DarkMagenta' # Purple Background
$rkmt = "rkm-tools"
# $host.UI.RawUI.WindowTitle = "rkm-tools"
$host.UI.RawUI.WindowTitle = "$rkmt - Running"
$Host.UI.RawUI.ForegroundColor = 'Yellow'       # Yellow Foreground
Clear-Host                                    
# Start-Sleep -Milliseconds 100
Write-Host @"


________   ___  __     _____ ______           _________   ________   ________   ___        ________      
|\   __  \ |\  \|\  \  |\   _ \  _   \        |\___   ___\|\   __  \ |\   __  \ |\  \      |\   ____\     
\ \  \|\  \\ \  \/  /|_\ \  \\\__\ \  \       \|___ \  \_|\ \  \|\  \\ \  \|\  \\ \  \     \ \  \___|_    
 \ \   _  _\\ \   ___  \\ \  \\|__| \  \           \ \  \  \ \  \\\  \\ \  \\\  \\ \  \     \ \_____  \   
  \ \  \\  \|\ \  \\ \  \\ \  \    \ \  \           \ \  \  \ \  \\\  \\ \  \\\  \\ \  \____ \|____|\  \  
   \ \__\\ _\ \ \__\\ \__\\ \__\    \ \__\           \ \__\  \ \_______\\ \_______\\ \_______\ ____\_\  \ 
    \|__|\|__| \|__| \|__| \|__|     \|__|            \|__|   \|_______| \|_______| \|_______||\_________\
                                                                                              \|_________|
                                                                                                          
"@
Write-Host "010010100110000101101001 0101001101101000011100100110010101100101 010100100110000101101101" -ForegroundColor DarkGray

# Check if the script is running as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Sleep -Seconds 1 
    Write-Host ""
    # Write-Host "----------------------------------------------------"
    Write-Host "> The script runs best with administrative privileges." -ForegroundColor Green
    Write-Host ">> Please re-Run as Admin !" -ForegroundColor Magenta
    Write-Host ""
    Exit
}

$systemDrive = $env:SystemDrive  # Dynamically get the system drive
$directoryPath = "$systemDrive\temp-rkm-tools"
if (-not (Test-Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath | Out-Null
}

do {    
    Start-Sleep -Milliseconds 800
    Write-Host ""   
    Write-Host "Welcome to rkm-tools" -ForegroundColor Red
    Write-Host ""

    # [Console]::ForegroundColor = 'Magenta'    
    Write-Host "[1] .bat/"          -ForegroundColor Magenta
    Write-Host "[2] bash/"          -ForegroundColor Magenta
    Write-Host "[3] ps/"            -ForegroundColor Magenta
    Write-Host "[4] py/"            -ForegroundColor Magenta
    Write-Host "[5] c/helloC++"     -ForegroundColor Magenta
    Write-Host "[6] misc/"          -ForegroundColor Magenta
    Write-Host ""
    Write-Host "[M] Microsoft Safety Scanner" -ForegroundColor Magenta
    Write-Host "[E] ESET Online Scanner" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "[0] EXIT" -ForegroundColor Blue
    # [Console]::ResetColor()

    Write-Host "`nChoose a menu option using your keyboard: " -ForegroundColor Green -NoNewline
    $choice = Read-Host

    Switch ($choice) 
    {
        "1" 
        {   
            Clear-Host
            Write-Host ""
            Write-Host "Batch Script Options" -ForegroundColor Cyan
            Write-Host ""
            Start-Sleep -Milliseconds 300
            Write-Host "[1] network-refresh.bat"
            Write-Host "[2] toggle-ethernet-admin.bat"
            Write-Host "[3] nircmd-set-brightness.bat"
            Write-Host "[4] end-task-edge.bat"
            Write-Host "[5] convert-mkv-to-mp4.bat"
            Write-Host "[6] list-imp-files.bat"
            Write-Host "[7] 1click-nircmd-set-brightness.bat"
            Write-Host "[8] "
            Write-Host "[9] "
            Write-Host "[10] open-chatgpt-replace-copilot_key.bat"
            Write-Host "[11] create-file.bat"
            Write-Host "[12] disable-recall.bat"
            Write-Host "[13] !-RESTART-TO-BIOS-!"
            Write-Host "[14] git-commit-all-changes.bat"
            Write-Host "[15] list-all-files-full-paths.bat"
            Write-Host "[16] clear-bin-and-temp.bat"
            Write-Host "[17] aio-package-updater.bat"
            Write-Host "[18] take-backup-compress-copy.bat"
            Write-Host "[19] 1click-reg-backup.bat"
            Write-Host "[20] hide-files-in-plain-sight.bat"
            Write-Host ""
            Write-Host "[21] install-my-terminal-shortcuts"
            Write-Host ""
            Write-Host "[0] Back to Main Menu" -ForegroundColor Blue
            Write-Host ""

            Write-Host "Choose an option using your keyboard: " -ForegroundColor Green -NoNewline
            $batChoice = Read-Host

            Switch ($batChoice)
            {
                "1"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/network-refresh.bat"
                    $scriptPath = "$directoryPath\network-refresh.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "2"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/toggle-ethernet-admin.bat"
                    $scriptPath = "$directoryPath\toggle-ethernet-admin.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "3"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/nircmd-set-brightness.bat"
                    $scriptPath = "$directoryPath\nircmd-set-brightness.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "4"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/end-task-edge.bat"
                    $scriptPath = "$directoryPath\end-task-edge.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    } 
                }
                "5"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/convert-mkv-to-mp4.bat"
                    $scriptPath = "$directoryPath\convert-mkv-to-mp4.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "6"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/list-imp-files.bat"
                    $scriptPath = "$directoryPath\list-imp-files.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "7"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/1click-nircmd-set-brightness.bat"
                    $scriptPath = "$directoryPath\1click-nircmd-set-brightness.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "8"
                {
                    Write-Host "Under Construction ..."
                }
                "9"
                {
                    Write-Host "Under Construction ..."
                }
                "10"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/open-chatgpt-replace-copilot_key.bat"
                    $scriptPath = "$directoryPath\open-chatgpt-replace-copilot_key.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "11"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/create-file.bat"
                    $scriptPath = "$directoryPath\create-file.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        & $scriptPath
                        # Start-Process -FilePath "cmd.exe" -ArgumentList "/k `"$scriptPath`"" -WindowStyle Normal
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "12"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/disable-recall.bat"
                    $scriptPath = "$directoryPath\disable-recall.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "13"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/shortcuts-i-have-in-system32/bootbios.cmd"
                    $scriptPath = "$directoryPath\bootbios.cmd"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        Start-Process -FilePath "cmd.exe" -ArgumentList "/k `"$scriptPath`"" -WindowStyle Normal
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "14"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/git-commit-all-changes.bat"
                    $scriptPath = "$directoryPath\git-commit-all-changes.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "15"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/list-all-files-full-paths.bat"
                    $scriptPath = "$directoryPath\list-all-files-full-paths.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "16"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/clear-bin-and-temp.bat"
                    $scriptPath = "$directoryPath\clear-bin-and-temp.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "17"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/aio-package-updater.bat"
                    $scriptPath = "$directoryPath\aio-package-updater.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "18"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/take-backup-compress-copy.bat"
                    $scriptPath = "$directoryPath\take-backup-compress-copy.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "19"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/1click-reg-backup.bat"
                    $scriptPath = "$directoryPath\1click-reg-backup.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "20" 
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/hide-files-in-plain-sight.bat"
                    $scriptPath = "$directoryPath\hide-files-in-plain-sight.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "21" 
                {
                    Clear-Host
                    Write-Host "`nSetting up terminal shortcuts..." -ForegroundColor Cyan
                    # System drive & paths
                    $systemDrive = $env:SystemDrive
                    $targetPath = "$systemDrive\rkm-shortcuts"
                    $zipPath = "$env:TEMP\rkm-repo.zip"
                    $extractPath = "$env:TEMP\rkm-repo"
                    try {
                        # Download & Extract GitHub Repo
                        Invoke-WebRequest -Uri "https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/archive/refs/heads/main.zip" -OutFile $zipPath
                        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
                        # Remove old folder if exists, then create fresh one
                        if (Test-Path $targetPath) { 
                            Remove-Item -Path $targetPath -Recurse -Force -ErrorAction Stop 
                        }
                        New-Item -Path $targetPath -ItemType Directory | Out-Null
                        # Move all files from repo folder
                        Move-Item -Path "$extractPath\a-noob-geek-pc-stuff-main\.bat\shortcuts-i-have-in-system32\*" -Destination $targetPath -Force
                        # Add to PATH if not already there
                        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
                        if ($currentPath -notlike "*$targetPath*") {
                            [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$targetPath", [System.EnvironmentVariableTarget]::Machine)
                        }
                        # Cleanup
                        Remove-Item -Path $zipPath, $extractPath -Recurse -Force -ErrorAction SilentlyContinue
                        Write-Host "`nTerminal shortcuts setup complete." -ForegroundColor Green
                        Write-Host "`nShortcut directory added to PATH: $targetPath`nYou can view and modify its contents as needed." -ForegroundColor Green
                    } catch {
                        Clear-Host
                        Write-Host "`n! ERROR: Unable to complete setup." -ForegroundColor Red
                        if ($_.Exception.Message -match "being used by another process") {
                            Write-Host "It looks like some files in '$targetPath' are in use." -ForegroundColor Yellow
                            Write-Host "Please close any programs using this folder and run this again." -ForegroundColor Yellow
                        } else {
                            Write-Host "An unexpected error occurred. Check for open programs or permission issues, then run this again." -ForegroundColor Yellow
                        }
                    }
                }
                "0"
                {
                    break
                }
                Default
                {
                    Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                    Write-Host ""
                }
            }
        }
        "2" 
        {    
            Clear-Host
            Write-Host ""
            Write-Host "Bash Script Options" -ForegroundColor Cyan
            Write-Host ""
            Start-Sleep -Milliseconds 300
            Write-Host "[1] install-must-have-pkgs.sh"
            Write-Host "[2] termux-install-must-have-pkgs.sh"
            Write-Host "[3] yt-dlp-termux-downloader-android.sh"
            Write-Host ""
            Write-Host "[0] Back to Main Menu" -ForegroundColor Blue
            Write-Host ""

            # Nested Menu Prompt
            Write-Host "Choose an option using your keyboard: " -ForegroundColor Green -NoNewline
            $bashChoice = Read-Host

            Switch ($bashChoice)
            {
                "1"
                {
                    # Define the URL and the save path
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/bash/install-must-have-pkgs.sh"
                    $scriptPath = "$directoryPath\install-must-have-pkgs.sh"

                    # Download the file from the URL and save it to the specified path
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath

                    # Notify the user about the saved script
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        Write-Host "Script saved to: $scriptPath" -ForegroundColor Green
                        Write-Host "Note: Use this script on a compatible OS, such as Linux."
                        Write-Host ""
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "2"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/bash/termux-install-must-have-pkgs.sh"
                    $scriptPath = "$directoryPath\termux-install-must-have-pkgs.sh"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        Write-Host "Script saved to: $scriptPath" -ForegroundColor Green
                        Write-Host "Note: Use this script on a compatible env./OS, such as Termux, Linux."
                        Write-Host ""
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "3"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/bash/yt-dlp-termux-downloader-android.sh"
                    $scriptPath = "$directoryPath\yt-dlp-termux-downloader-android.sh"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        Write-Host "Script saved to: $scriptPath" -ForegroundColor Green
                        Write-Host "Note: Use this script on a compatible env./OS, such as Termux, Linux."
                        Write-Host ""
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "0"
                {
                    break
                }
                Default
                {
                    Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                    Write-Host ""
                }
            }
        }
        "3" 
        {
            Clear-Host
            Write-Host ""
            Write-Host "Powershell Script Options" -ForegroundColor Cyan
            Write-Host ""
            Start-Sleep -Milliseconds 300
            Write-Host "[1] list-all-programs.ps1"
            Write-Host "[2] get-repo-raw-links.ps1"
            Write-Host "[3] remove-lines.ps1"
            Write-Host "[4] text-combine-scripts.ps1"
            Write-Host "[5] shut-sleep-wake-restart-bsod-counter.ps1"
            Write-Host "[6] speedtest.ps1"
            Write-Host ""
            Write-Host "[0] Back to Main Menu" -ForegroundColor Blue
            Write-Host ""

            Write-Host "Choose an option using your keyboard: " -ForegroundColor Green -NoNewline
            $psChoice = Read-Host

            Switch ($psChoice)
            {
                "1"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/ps/list-all-programs.ps1"
                    $scriptPath = "$directoryPath\list-all-programs.ps1"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Unblock-File -Path $scriptPath
                        & PowerShell.exe -ExecutionPolicy Bypass -File $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "2"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/ps/get-repo-raw-links.ps1"
                    $scriptPath = "$directoryPath\get-repo-raw-links.ps1"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Unblock-File -Path $scriptPath
                        & PowerShell.exe -ExecutionPolicy Bypass -File $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "3"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/ps/remove-lines.ps1"
                    $scriptPath = "$directoryPath\remove-lines.ps1"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Unblock-File -Path $scriptPath
                        & PowerShell.exe -ExecutionPolicy Bypass -File $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "4"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/ps/text-combine-scripts.ps1"
                    $scriptPath = "$directoryPath\text-combine-scripts.ps1"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        Unblock-File -Path $scriptPath
                        & PowerShell.exe -ExecutionPolicy Bypass -File $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "5"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/ps/shut-sleep-wake-restart-bsod-counter.ps1"
                    $scriptPath = "$directoryPath\shut-sleep-wake-restart-bsod-counter.ps1"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        Unblock-File -Path $scriptPath
                        & PowerShell.exe -ExecutionPolicy Bypass -File $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "6"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/ps/speedtest.ps1"
                    $scriptPath = "$directoryPath\speedtest.ps1"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host ""
                        Unblock-File -Path $scriptPath
                        & PowerShell.exe -ExecutionPolicy Bypass -File $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "0"
                {
                    break
                }
                Default
                {
                    Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                    Write-Host ""
                }
            } # # FUNCTIONs can also be used, instead of same repeat codes
        }
        "4" 
        {
            # Notify the user about Python installation requirement
            Clear-Host
            Write-Host ""
            Write-Host "IMPORTANT: These scripts requires Python to be installed and *added to the PATH* to work." -ForegroundColor Yellow
            Write-Host "If Python is not installed, download it from https://www.python.org/downloads/" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Press any key to continue..." -ForegroundColor Green
            Read-Host

            Clear-Host
            Write-Host ""
            Write-Host "Python Script Options" -ForegroundColor Cyan
            Write-Host ""
            Start-Sleep -Milliseconds 300
            Write-Host "[1] real-time-mouse-co-ord.py"
            Write-Host "[2] get-imdb-id-fast.py"
            Write-Host "[3] folder-real-time-monitor.py"
            Write-Host "[4] xml-extract-details.py"
            Write-Host "[5] password-generator.py"
            Write-Host "[6] get-first-boot-time.py"
            Write-Host "[7] file-hide-extract.py"
            Write-Host "[8] split-anything-by-size.py"
            Write-Host "[9] list-file-extensions.py"
            Write-Host "[10] BEST-YOUTUBE-DOWNLOADER.py"
            Write-Host "[11] bookmarks.html-to-text-csv.py"
            Write-Host "[12] ytmusic-multi-search.py"
            Write-Host "[13] text-encrypt-decrypt.py"
            Write-Host ""
            Write-Host "[14] split-join-files program"
            Write-Host ""
            Write-Host "[0] Back to Main Menu" -ForegroundColor Blue
            Write-Host ""

            Write-Host "Choose an option using your keyboard: " -ForegroundColor Green -NoNewline
            $pyChoice = Read-Host

            Switch ($pyChoice)
            {
                "1"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/real-time-mouse-co-ord.py"
                    $scriptPath = "$directoryPath\real-time-mouse-co-ord.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                        # Start-Process python -ArgumentList $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "2"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/get-imdb-id-fast.py"
                    $scriptPath = "$directoryPath\get-imdb-id-fast.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "3"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/folder-real-time-monitor.py"
                    $scriptPath = "$directoryPath\folder-real-time-monitor.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Start-Process python -ArgumentList $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "4"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/xml-extract-details.py"
                    $scriptPath = "$directoryPath\xml-extract-details.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "5"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/password-generator.py"
                    $scriptPath = "$directoryPath\password-generator.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "6"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/get-first-boot-time.py"
                    $scriptPath = "$directoryPath\get-first-boot-time.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "7"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/file-hide-extract.py"
                    $scriptPath = "$directoryPath\file-hide-extract.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "8"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/split-anything-by-size.py"
                    $scriptPath = "$directoryPath\split-anything-by-size.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "9"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/list-file-extensions.py"
                    $scriptPath = "$directoryPath\list-file-extensions.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "10"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/BEST-YOUTUBE-DOWNLOADER.py"
                    $scriptPath = "$directoryPath\BEST-YOUTUBE-DOWNLOADER.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "11"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/bookmarks.html-to-text-csv.py"
                    $scriptPath = "$directoryPath\bookmarks.html-to-text-csv.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "12"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/ytmusic-multi-search.py"
                    $scriptPath = "$directoryPath\ytmusic-multi-search.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "13"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/text-encrypt-decrypt.py"
                    $scriptPath = "$directoryPath\text-encrypt-decrypt.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "14"
                {
                    Clear-Host
                    Write-Host ""
                    Write-Host "Split-Join-Files Program Options" -ForegroundColor Cyan
                    Write-Host ""
                    Start-Sleep -Milliseconds 300
                    Write-Host "[1] info.txt - *MUST READ FIRST*"
                    Write-Host "[2] split-files-binary.py"
                    Write-Host "[3] join-files-binary.py"
                    Write-Host ""
                    Write-Host "[0] Back to Main Menu" -ForegroundColor Blue
                    Write-Host ""
        
                    Write-Host "Choose an option using your keyboard: " -ForegroundColor Green -NoNewline
                    $sjfChoice = Read-Host
        
                    Switch ($sjfChoice)
                    {
                        "1"
                        {
                            $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/split-join-files/info.txt"
                            $scriptPath = "$directoryPath\info.txt"
                            Invoke-WebRequest -Uri $url -OutFile $scriptPath
                            if (Test-Path $scriptPath) {
                                Start-Process "notepad.exe" -ArgumentList $scriptPath
                            } else {
                                Write-Host "Failed to download the file." -ForegroundColor Red
                            }
                        }
                        "2"
                        {
                            $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/split-join-files/split-files-binary.py"
                            $scriptPath = "$directoryPath\split-files-binary.py"
                            Invoke-WebRequest -Uri $url -OutFile $scriptPath
                            if (Test-Path $scriptPath) {
                                Start-Process python -ArgumentList $scriptPath
                            } else {
                                Write-Host "Failed to download the script." -ForegroundColor Red
                            }
                        }
                        "3"
                        {
                            $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/split-join-files/join-files-binary.py"
                            $scriptPath = "$directoryPath\join-files-binary.py"
                            Invoke-WebRequest -Uri $url -OutFile $scriptPath
                            if (Test-Path $scriptPath) {
                                Start-Process python -ArgumentList $scriptPath
                            } else {
                                Write-Host "Failed to download the script." -ForegroundColor Red
                            }                            
                        }
                        "0"
                        {
                            break                            
                        }
                        Default
                        {
                            Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                            Write-Host ""
                        }
                    }
                }
                "0"
                {
                    break
                }
                Default
                {
                    Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                    Write-Host ""
                }                
            }
        }
        "5" 
        {
            $url = "https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/raw/refs/heads/main/c/hello-with-systempause.exe"
            $exePath = "$directoryPath\hello-with-systempause.exe"
            Invoke-WebRequest -Uri $url -OutFile $exePath
            if (Test-Path $exePath) {
                Start-Process -FilePath $exePath
            } else {
                Write-Host "Failed to download the .exe file." -ForegroundColor Red
            }
        }
        "6" 
        {
            Clear-Host
            Write-Host ""
            Write-Host "Miscellaneous Tools" -ForegroundColor Cyan
            Write-Host ""
            Start-Sleep -Milliseconds 300
            Write-Host "[1] set-wukong-to-high-priority.reg"
            Write-Host "[2] remove-wukong-high-priority.reg"
            Write-Host "[3] kill-valorant.bat"
            Write-Host "[4] all-my-bookmarks.7z"
            Write-Host "[5] get-imdb-id-link_in_A-id_in_B.xlsx"
            Write-Host "[6] drawn-me.png"
            Write-Host "[7] GET-ALL-TORRENT-TRACKERS"
            Write-Host ""
            Write-Host "[8] my-espanso-config/package"
            Write-Host ""
            Write-Host "[0] Back to Main Menu" -ForegroundColor Blue
            Write-Host ""

            Write-Host "Choose an option using your keyboard: " -ForegroundColor Green -NoNewline
            $miscChoice = Read-Host

            Switch ($miscChoice)
            {
                "1"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/misc/set-wukong-to-high-priority.reg/set-wukong-to-high-priority.reg"
                    $regPath = "$directoryPath\set-wukong-to-high-priority.reg"
                    Invoke-WebRequest -Uri $url -OutFile $regPath
                    if (Test-Path $regPath) {
                        Start-Process -FilePath "regedit.exe" -ArgumentList "/s", $regPath -Wait
                    } else {
                        Write-Host "Failed to download the .reg file." -ForegroundColor Red
                    }
                }
                "2"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/misc/set-wukong-to-high-priority.reg/remove-wukong-high-priority.reg"
                    $regPath = "$directoryPath\remove-wukong-high-priority.reg"
                    Invoke-WebRequest -Uri $url -OutFile $regPath
                    if (Test-Path $regPath) {
                        Start-Process -FilePath "regedit.exe" -ArgumentList "/s", $regPath -Wait
                    } else {
                        Write-Host "Failed to download the .reg file." -ForegroundColor Red
                    }
                }
                "3"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/misc/valo-bullsht/kill-valorant.bat"
                    $batPath = "$directoryPath\kill-valorant.bat"
                    Invoke-WebRequest -Uri $url -OutFile $batPath
                    if (Test-Path $batPath) {
                        Start-Process -FilePath $batPath
                    } else {
                        Write-Host "Failed to download the .bat file." -ForegroundColor Red
                    }
                }
                "4"
                {
                    $desktopPath = [Environment]::GetFolderPath("Desktop")
                    $url = "https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/raw/refs/heads/main/misc/all-my-bookmarks.7z"
                    $archivePath = "$desktopPath\all-my-bookmarks.7z"
                    Invoke-WebRequest -Uri $url -OutFile $archivePath
                    if (Test-Path $archivePath) {
                        Write-Host ""
                        Write-Host "The file has been saved to your Desktop." -ForegroundColor Cyan
                    } else {
                        Write-Host "Failed to download the .7z file." -ForegroundColor Red
                    }
                }
                "5"
                {
                    $url = "https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/raw/refs/heads/main/misc/get-imdb-id-link_in_A-id_in_B.xlsx"
                    $xlsxPath = "$directoryPath\get-imdb-id-link_in_A-id_in_B.xlsx"
                    Invoke-WebRequest -Uri $url -OutFile $xlsxPath
                    if (Test-Path $xlsxPath) {
                        Start-Process -FilePath $xlsxPath
                    } else {
                        Write-Host "Failed to download the .xlsx file." -ForegroundColor Red
                    }
                }
                "6"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/main/misc/drawn-me.png"
                    $imagePath = "$directoryPath\drawn-me.png"
                    Invoke-WebRequest -Uri $url -OutFile $imagePath
                    if (Test-Path $imagePath) {
                        Start-Process -FilePath $imagePath
                    } else {
                        Write-Host "Failed to download the .png file." -ForegroundColor Red
                    }
                }
                "7" 
                {
                    Clear-Host
                    Write-Host ""
                    Write-Host "Downloading and Merging Tracker Lists..."
                    $url1 = "https://raw.githubusercontent.com/XIU2/TrackersListCollection/refs/heads/master/all.txt"
                    $url2 = "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt"
                    # $outputPath = "$directoryPath\all-trackers.txt"
                    $outputPath = "$env:USERPROFILE\Desktop\all-trackers.txt"
                    try {
                        $trackers1 = Invoke-WebRequest -Uri $url1 -UseBasicParsing | Select-Object -ExpandProperty Content
                        $trackers2 = Invoke-WebRequest -Uri $url2 -UseBasicParsing | Select-Object -ExpandProperty Content
                        $mergedContent = "$trackers1`r`n$trackers2"
                        $mergedContent | Set-Content -Path $outputPath -Encoding UTF8
                        # Use clip.exe for full clipboard content
                        $mergedContent | clip
                        Write-Host ""
                        Write-Host "Done. Trackers saved to: $outputPath"
                        Write-Host "        ...       "
                        Write-Host "+ COPIED TO CLIPBOARD +" -ForegroundColor Green
                    } catch {
                        Write-Host "Error: $($_.Exception.Message)"
                    }
                    if (Test-Path $outputPath) {
                        Start-Process -FilePath $outputPath
                    } else {
                        Write-Host "Failed to open all-trackers.txt" -ForegroundColor Red
                    }
                }
                "8"
                {
                    Write-Host "Fetching and zipping the contents of Espanso..."
                    # Define the destination path
                    $destPath = "$env:USERPROFILE\Desktop\espanso-rkm-pkg.zip"
                    # Download the repo contents
                    $repoUrl = "https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff/archive/refs/heads/main.zip"
                    $tempZip = "$env:TEMP\espanso_temp.zip"
                    $tempExtract = "$env:TEMP\espanso_extract"
                    # Download the ZIP file
                    Invoke-WebRequest -Uri $repoUrl -OutFile $tempZip
                    # Extract the downloaded zip
                    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
                    # Define the source folder inside the extracted archive
                    $espansoPath = "$tempExtract\a-noob-geek-pc-stuff-main\misc\espanso"
                    # Zip only the espanso folder
                    Compress-Archive -Path $espansoPath -DestinationPath $destPath -Force
                    # Cleanup
                    Remove-Item -Path $tempZip -Force
                    Remove-Item -Path $tempExtract -Recurse -Force
                    # Show the path of the saved ZIP file
                    Write-Host "Espanso backup saved at: $destPath"
                }
                "0"
                {
                    break
                }
                Default
                {
                    Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                    Write-Host ""
                }
            }
        }
        "M" 
        {
            Clear-Host
            Write-Host "Downloading and running Microsoft Safety Scanner..." -ForegroundColor Cyan
            $mssUrl = "https://go.microsoft.com/fwlink/?LinkId=212732"
            $mssPath = "$directoryPath\msert.exe"
            Invoke-WebRequest -Uri $mssUrl -OutFile $mssPath
            if (Test-Path $mssPath) {
                # Start-Process -FilePath $mssPath -ArgumentList "/q" -Wait
                Start-Process -FilePath $mssPath
            } else {
                Write-Host "Failed to download Microsoft Safety Scanner." -ForegroundColor Red
            }
        }
        "E" 
        {
            Clear-Host
            Write-Host "Downloading and running ESET Online Scanner..." -ForegroundColor Cyan
            $esetUrl = "https://download.eset.com/com/eset/tools/online_scanner/latest/esetonlinescanner.exe"
            $esetPath = "$directoryPath\esetonlinescanner.exe"
            Invoke-WebRequest -Uri $esetUrl -OutFile $esetPath
            if (Test-Path $esetPath) {
                Start-Process -FilePath $esetPath
            } else {
                Write-Host "Failed to download ESET Online Scanner." -ForegroundColor Red
            }
        }
        "0" 
        {
            Start-Sleep -Seconds 1
            # Delete the temp folder before exiting
            if (Test-Path $directoryPath) {
                Remove-Item -Path $directoryPath -Recurse
                Write-Host "Temporary folder deleted." -ForegroundColor Red
            }
            # Exit
            Write-Host ""
            Write-Host "Exiting... Goodbye!" -ForegroundColor Blue
            Start-Sleep -Seconds 1
            break
        }
        Default 
        {
            Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
            Write-Host ""
        }
    }
Write-Host ""

} while ($choice -ne "0")

$host.UI.RawUI.WindowTitle = "$rkmt - Completed"
Start-Sleep -Seconds 1
