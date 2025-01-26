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
Write-Host "011100100110101101101101 0101010001001111010011110100110001010011" -ForegroundColor DarkGray

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
            Write-Host "[8] yt-dlp_downloader.bat"
            Write-Host "[9] split-video-by-mins-lossless.bat"
            Write-Host "[10] open-chatgpt-replace-copilot_key.bat"
            Write-Host "[11] create-file.bat"
            Write-Host "[12] disable-recall.bat"
            Write-Host "[13] update-choco-scoop-pip-npm-installs.bat"
            Write-Host "[14] git-commit-all-changes.bat"
            Write-Host "[15] list-all-files-full-paths.bat"
            Write-Host "[16] clear-bin-and-temp.bat"
            Write-Host "[17] aio-package-updater.bat"
            Write-Host "[18] take-backup-compress-copy.bat"
            Write-Host "[19] 1click-reg-backup.bat"
            Write-Host "[20] reverse-file-name_and_ext.bat"
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
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/yt-dlp_downloader.bat"
                    $scriptPath = "$directoryPath\yt-dlp_downloader.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "9"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/split-video-by-mins-lossless.bat"
                    $scriptPath = "$directoryPath\split-video-by-mins-lossless.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
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
                        & $scriptPath
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
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/update-choco-scoop-pip-npm-installs.bat"
                    $scriptPath = "$directoryPath\update-choco-scoop-pip-npm-installs.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        & $scriptPath
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
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/.bat/reverse-file-name_and_ext.bat"
                    $scriptPath = "$directoryPath\reverse-file-name_and_ext.bat"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Start-Process -FilePath $scriptPath
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
            Write-Host "[10] best-youtube-downloader.py"
            Write-Host "[11] bookmarks.html-to-text-csv.py"
            Write-Host ""
            Write-Host "[12] split-join-files program"
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
                        # python $scriptPath
                        Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "10"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/py/best-youtube-downloader.py"
                    $scriptPath = "$directoryPath\best-youtube-downloader.py"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        python $scriptPath
                        # Start-Process python -ArgumentList $scriptPath
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
                        # Start-Process python -ArgumentList $scriptPath
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "12"
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
            Write-Host "[1] set wukong to high priority.reg"
            Write-Host "[2] remove wukong high priority.reg"
            Write-Host "[3] kill-valorant.bat"
            Write-Host "[4] all-my-bookmarks.7z"
            Write-Host "[5] get-imdb-id-link_in_A-id_in_B.xlsx"
            Write-Host "[6] lock-unlock-pswrd-folder.bat"
            Write-Host ""
            Write-Host "[0] Back to Main Menu" -ForegroundColor Blue
            Write-Host ""

            Write-Host "Choose an option using your keyboard: " -ForegroundColor Green -NoNewline
            $miscChoice = Read-Host

            Switch ($miscChoice)
            {
                "1"
                {
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/misc/set%20wukong%20to%20high%20priority.reg/set-wukong-to-high-priority.reg"
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
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/misc/set%20wukong%20to%20high%20priority.reg/remove-wukong-high-priority.reg"
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
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/misc/valo%20bs/kill-valorant.bat"
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
                    $url = "https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/refs/heads/main/misc/lock-unlock-pswrd-folder.bat"
                    $batPath = "$directoryPath\lock-unlock-pswrd-folder.bat"
                    Invoke-WebRequest -Uri $url -OutFile $batPath
                    if (Test-Path $batPath) {
                        Write-Host ""
                        Write-Host "The script creates a password-protected "f o l d e r" on the desktop, locks or unlocks it on subsequent runs, and enhances security with hidden and system attributes."
                        & $batPath
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
            # Exit
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
