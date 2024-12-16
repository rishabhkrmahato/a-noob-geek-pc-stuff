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

# Set Console Colors
# $Host.UI.RawUI.BackgroundColor = 'DarkMagenta' # Purple Background
$Host.UI.RawUI.ForegroundColor = 'Yellow'       # Yellow Foreground
Clear-Host                                    

# ASCII Art
Write-Host @"


________   ___  __     _____ ______           _________   ________   ________   ___        ________      
|\   __  \ |\  \|\  \  |\   _ \  _   \        |\___   ___\|\   __  \ |\   __  \ |\  \      |\   ____\     
\ \  \|\  \\ \  \/  /|_\ \  \\\__\ \  \       \|___ \  \_|\ \  \|\  \\ \  \|\  \\ \  \     \ \  \___|_    
 \ \   _  _\\ \   ___  \\ \  \\|__| \  \           \ \  \  \ \  \\\  \\ \  \\\  \\ \  \     \ \_____  \   
  \ \  \\  \|\ \  \\ \  \\ \  \    \ \  \           \ \  \  \ \  \\\  \\ \  \\\  \\ \  \____ \|____|\  \  
   \ \__\\ _\ \ \__\\ \__\\ \__\    \ \__\           \ \__\  \ \_______\\ \_______\\ \_______\ ____\_\  \ 
    \|__|\|__| \|__| \|__| \|__|     \|__|            \|__|   \|_______| \|_______| \|_______||\_________\
                                                                                              \|_________|
                                                                                                          
                                                                                                          
011100100110101101101101 0101010001001111010011110100110001010011 

"@

# Ensure the directory exists
$directoryPath = "C:\temp-rkm-tools"
if (-not (Test-Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath
}

do {
    # Display Menu
    Write-Host "Welcome to rkm-tools" -ForegroundColor Red
    # Write-Host "`nPlease choose an option from the menu below:`n"
    Write-Host ""

    Write-Host "[1] .bat/"
    Write-Host "[2] bash/"
    Write-Host "[3] ps/"
    Write-Host "[4] py/"
    Write-Host "[5] c/"
    Write-Host "[6] misc/"
    Write-Host ""
    Write-Host "[0] EXIT"

    # User Prompt
    Write-Host "`nChoose a menu option using your keyboard: " -ForegroundColor Green -NoNewline
    $choice = Read-Host

    # Handle User Choice
    Switch ($choice) 
    {
        "1" 
        {   
            Clear-Host
            Write-Host "Batch Script Options" -ForegroundColor Cyan
            Write-Host ""
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
            Write-Host ""
            Write-Host "[0] Back to Main Menu"
            Write-Host ""

            Write-Host "Choose a bash script option using your keyboard: " -ForegroundColor Green -NoNewline
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
                    # # Create the directory if it doesn't exist
                    # if (-not (Test-Path "C:\Scripts")) {
                    #     New-Item -ItemType Directory -Path "C:\Scripts"
                    # }
                    # # Download the script to C:\Scripts
                    # Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    # # Check if the script was successfully downloaded
                    # if (Test-Path $scriptPath) {
                    #     # Run the downloaded script
                    #     & $scriptPath
                    # } else {
                    #     Write-Host "Failed to download the script." -ForegroundColor Red
                    # }
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
            Write-Host "Bash Script Options" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "[1] install-must-have-pkgs.sh"
            Write-Host "[2] termux-install-must-have-pkgs.sh"
            Write-Host "[3] yt-dlp-termux-downloader-android.sh"
            Write-Host ""
            Write-Host "[0] Back to Main Menu"
            Write-Host ""

            # Nested Menu Prompt
            Write-Host "Choose a bash script option using your keyboard: " -ForegroundColor Green -NoNewline
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
                        Write-Host "Script saved to: $scriptPath" -ForegroundColor Green
                        Write-Host "Note: Use this script on a compatible OS, such as Linux."
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
                        Write-Host "Script saved to: $scriptPath" -ForegroundColor Green
                        Write-Host "Note: Use this script on a compatible env./OS, such as Termux, Linux."
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "3"
                {
                    $url = ""
                    $scriptPath = "$directoryPath\"
                    Invoke-WebRequest -Uri $url -OutFile $scriptPath
                    if (Test-Path $scriptPath) {
                        Write-Host "Script saved to: $scriptPath" -ForegroundColor Green
                        Write-Host "Note: Use this script on a compatible env./OS, such as Termux, Linux."
                    } else {
                        Write-Host "Failed to download the script." -ForegroundColor Red
                    }
                }
                "0"
                {
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
        }
        "4" 
        {
        }
        "5" 
        {
        }
        "6" 
        {
        }
        "0" 
        {
            # Exit
            Write-Host "Exiting... Goodbye!" -ForegroundColor Cyan
            break
        }        
        Default 
        {
            Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
            Write-Host ""
        }
    }
Write-Host ""
Start-Sleep -Seconds 1
} while ($choice -ne "0")


