<#
.SYNOPSIS
RKM-Tools: A collection of handy scripts and tools for PC automation and optimization.

.DESCRIPTION
This script serves as a launcher and menu system for various PowerShell scripts hosted in the 
RKM GitHub repository. It provides easy access to tasks like system cleanup, software installation, 
network troubleshooting, and more.

.AUTHOR
Rishabh Kumar Mahato (Sonu)

.VERSION
1.0.0

.LINK
GitHub Repository: https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff

.NOTES
- Always run this script with administrative privileges for optimal functionality.
- Ensure you have an active internet connection to fetch and run remote scripts.

#>

# Set Console Colors
# $Host.UI.RawUI.BackgroundColor = 'DarkMagenta' # Purple Background
$Host.UI.RawUI.ForegroundColor = 'Yellow'      # Yellow Foreground
Clear-Host                                     # Clear screen to apply colors

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

do {
    # Display Menu
    Write-Host "Welcome to rkm-tools" -ForegroundColor Cyan
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
    Write-Host "`nChoose a menu option using your keyboard (1,2,3,4,5,6, 0): " -ForegroundColor Green -NoNewline
    $choice = Read-Host

    # Handle User Choice
    Switch ($choice) 
    {
        "1" 
        {   
        }
        "2" 
        {    
            Clear-Host
            Write-Host "Bash Script Options" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "[1] install-must-have-pkgs.sh"
            Write-Host "[2] termux-install-must-have-pkgs.sh"
            Write-Host "[3] yt-dlp+termux-downloader-android.sh"
            Write-Host ""
            Write-Host "[0] Back to Main Menu"
            Write-Host ""

            # Nested Menu Prompt
            Write-Host "Choose a bash script option using your keyboard (1,2,3,0): " -ForegroundColor Green -NoNewline
            $bashChoice = Read-Host

            Switch ($bashChoice)
            {
                "1"
                {
                }
                "2"
                {
                }
                "3"
                {
                }
                "0"
                {
                }
                Default
                {
                    Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
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
        }
    }
} while ($choice -ne "0")


