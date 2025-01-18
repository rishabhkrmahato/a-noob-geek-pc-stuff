"""
==============================================================================================

Description:

BEST SIMPLE CLEAR YouTube Video Downloader

This script downloads a YouTube video in the best available 
video and audio quality using the `yt-dlp` utility. It validates 
the YouTube link, fetches available formats, and combines 
video and audio streams into a single file.

Key Features:
- Validates YouTube video links and ensures they are not playlists.
- Checks if `yt-dlp` is installed and updates or installs it as needed.
- Fetches available video and audio formats from YouTube.
- Automatically selects the best video and audio formats based on bitrate.
- Downloads and merges video and audio streams.
- Provides clear and color-coded terminal outputs for each step.

Usage:
1. Run the script in a Python environment (installed python on system and added to path). 
   (IN TERMINAL: python best-yt-dlp-automated.py)
2. Enter a valid YouTube video link when prompted.
3. The script will handle the rest, including format selection and downloading.

Dependencies:
- Python 3.x
- `yt-dlp` Python module (automatically installed/updated by the script).
- `requests` (to fetch the latest version info from GitHub).
- `packaging` (for version comparisons).

Output:
- Downloads the YouTube video in the best available quality and saves it 
  in the current working directory.

Error Handling:
- Displays detailed error messages if a step fails.
- Exits gracefully if invalid inputs or unexpected issues occur.

Notes:
- Ensure an active internet connection for fetching and downloading resources.
- The downloaded file will be saved with its title as the filename in the 
  current working directory.

==============================================================================================
"""

import os
import sys
import subprocess
import re
import glob
import requests
from shutil import which
from packaging import version

# import os
# os.system('chcp 65001 >nul')  # Set encoding to UTF-8 for the session
# sys.stdout.reconfigure(encoding='utf-8')  # Ensure Python stdout is UTF-8

# Colors for terminal output
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def print_color(message, color):
    print(f"{color}{message}{Colors.ENDC}")

# def check_yt_dlp():
#     """
#     Checks if yt-dlp is installed, up-to-date, and in PATH. Installs or updates if necessary.
#     """
#     print_color("\nChecking yt-dlp installation...", Colors.HEADER)
#     yt_dlp_installed = which("yt-dlp")
#     if yt_dlp_installed is None:
#         print_color("yt-dlp not found. Installing...", Colors.WARNING)
#         subprocess.run(["pip", "install", "yt-dlp"], check=True)
#     else:
#         print_color("yt-dlp is installed. Verifying version...", Colors.OKBLUE)
#         current_version = subprocess.run(["yt-dlp", "--version"], capture_output=True, text=True).stdout.strip()
#         latest_version = requests.get("https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest").json()["tag_name"]
#         if version.parse(current_version) < version.parse(latest_version):
#             print_color(f"Updating yt-dlp to the latest version {latest_version}...", Colors.WARNING)
#             subprocess.run(["pip", "install", "--upgrade", "yt-dlp"], check=True)
#         else:
#             print_color("yt-dlp is up-to-date!", Colors.OKGREEN)

def check_yt_dlp():
    """
    Checks if yt-dlp is installed and up-to-date.
    If outdated, it opens a new elevated Python script to update yt-dlp using Chocolatey.
    """
    print_color("\nChecking yt-dlp installation...", Colors.HEADER)

    # Check if yt-dlp is installed
    yt_dlp_installed = which("yt-dlp")
    if yt_dlp_installed is None:
        print_color("yt-dlp not found. Installing via Chocolatey in elevated mode...", Colors.WARNING)
        open_elevated_updater()
        return

    # Check the current version of yt-dlp
    print_color("yt-dlp is installed. Verifying version...", Colors.OKBLUE)
    current_version = subprocess.run(["yt-dlp", "--version"], capture_output=True, text=True).stdout.strip()
    latest_version = requests.get("https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest").json()["tag_name"]

    if version.parse(current_version) < version.parse(latest_version):
        print_color(f"Updating yt-dlp to the latest version {latest_version} via Chocolatey...", Colors.WARNING)
        open_elevated_updater()
    else:
        print_color("yt-dlp is up-to-date!", Colors.OKGREEN)

def open_elevated_updater():
    """
    Opens a new elevated Python script to update yt-dlp using Chocolatey.
    Waits for the elevated process to finish before continuing.
    Deletes the temporary script after execution.
    """
    print_color("Opening elevated Python script to update yt-dlp...", Colors.HEADER)
    
    # Path to the new Python script
    updater_script = "update_yt_dlp.py"

    # Write the updater script
    with open(updater_script, "w", encoding="utf-8") as f:
        f.write(
            '''import os
import time
import subprocess

def print_message(message):
    print(f"\\033[92m{message}\\033[0m")

def print_warning(message):
    print(f"\\033[93m{message}\\033[0m")

def install_choco():
    """
    Checks if Chocolatey is installed. If not, installs it.
    """
    try:
        # Check if Chocolatey is available via `choco -v`
        subprocess.run(["choco", "-v"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        print_message("Chocolatey is already installed.")
    except subprocess.CalledProcessError:
        # If `choco` command fails, check the file path
        if not os.path.exists(r"C:\\ProgramData\\chocolatey\\bin\\choco.exe"):
            print_message("Chocolatey not found. Installing...")
            subprocess.run([
                "powershell",
                "-NoProfile",
                "-ExecutionPolicy", "Bypass",
                "-Command",
                "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; "
                "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
            ], check=True)
        else:
            print_warning("WARNING: Chocolatey was found at the expected path, but the 'choco' command is not functional.")
            print_warning("You may need to add Chocolatey to your PATH environment variable or fix the installation.")

def update_yt_dlp():
    print_message("Updating yt-dlp via Chocolatey...")
    subprocess.run(["choco", "upgrade", "yt-dlp", "-y"], check=True)

if __name__ == "__main__":
    try:
        install_choco()
        update_yt_dlp()
        print_message("Update completed. Waiting for 5 seconds before closing...")
        time.sleep(5)
    except subprocess.CalledProcessError as e:
        print(f"\\033[91mError: {e}\\033[0m")
        time.sleep(5)

    # Delete the script after execution
    script_path = os.path.abspath(__file__)
    print_message(f"Deleting script: {script_path}")
    os.remove(script_path)
    '''
        )

    # Open the new script in an elevated terminal and wait for it to complete
    subprocess.run([
        "powershell",
        "-NoProfile",
        "-Command",
        f"Start-Process python -ArgumentList '{updater_script}' -Verb RunAs -Wait"
    ], check=True)

    print_color("Elevated updater script executed. Continuing main script...", Colors.OKGREEN)

def is_valid_youtube_link(link):
    """
    Validates a YouTube video link and ensures it's not a playlist.
    """
    print_color("\nValidating YouTube link...", Colors.HEADER)
    if not re.match(r"^https?://(www\.)?(youtube\.com/(watch\?v=|shorts/)|youtu\.be/)", link):
    # if not re.match(r"^https?://(www\.)?(youtube\.com/watch\?v=|youtu\.be/)", link):
        print_color("Invalid YouTube URL. Please enter a valid video link.", Colors.FAIL)
        sys.exit(1)
    if "list=" in link:
        print_color("The link is for a playlist. Please provide a single video link.", Colors.FAIL)
        sys.exit(1)
    response = requests.get(link)
    if response.status_code != 200:
        print_color("The video link is not accessible. Please check the URL.", Colors.FAIL)
        sys.exit(1)
    print_color("YouTube link is valid!", Colors.OKGREEN)

def fetch_formats(link):
    """
    Uses yt-dlp to fetch available video and audio formats.
    """
    print_color("\nFetching formats using yt-dlp...", Colors.HEADER)
    try:
        result = subprocess.run(["yt-dlp", "-F", link], capture_output=True, text=True, check=True).stdout
        print_color("\nFetched Format Details:\n", Colors.OKCYAN)
        print(result)
        return result
    except subprocess.CalledProcessError:
        print_color("Failed to fetch formats. Ensure the link is correct.", Colors.FAIL)
        sys.exit(1)

def select_formats(format_details):
    """
    Parses format details and selects the best video and audio formats based on criteria.
    """
    print_color("\nSelecting the best formats...", Colors.HEADER)
    video_id, audio_id = None, None
    highest_video_tbr, highest_audio_tbr = 0, 0

    for line in format_details.splitlines():
        if "video only" in line:
            try:
                tbr_match = re.search(r"\b(\d+)k\b", line)
                tbr = int(tbr_match.group(1)) if tbr_match else 0
                if tbr > highest_video_tbr:
                    highest_video_tbr = tbr
                    video_id = re.search(r"^\d+", line).group(0)
            except AttributeError:
                continue

        if "audio only" in line:
            try:
                tbr_match = re.search(r"\b(\d+)k\b", line)
                tbr = int(tbr_match.group(1)) if tbr_match else 0
                if "drc" not in line.lower() and tbr > highest_audio_tbr:
                    highest_audio_tbr = tbr
                    audio_id = re.search(r"^\d+", line).group(0)
            except AttributeError:
                continue

    if not video_id:
        print_color("No suitable video format found. Please check the video link.", Colors.FAIL)
    if not audio_id:
        print_color("No suitable audio format found. Please check the video link.", Colors.FAIL)

    if video_id and audio_id:
        print_color(f"Selected Video ID: {video_id}, Audio ID: {audio_id}", Colors.OKGREEN)
        return video_id, audio_id
    else:
        sys.exit(1)

def download_video(link, video_id, audio_id):
    """
    Downloads the selected video and audio streams using yt-dlp.
    """
    print_color("\nStarting download...", Colors.HEADER)
    output_template = os.path.join(os.getcwd(), "%(title)s.%(ext)s")
    command = f'yt-dlp -f "{video_id}+{audio_id}" -o "{output_template}" "{link}"'
    # command = f'yt-dlp -f "{video_id}+{audio_id}" -o "{output_template}" {link}' 
    try:
        subprocess.run(command, shell=True, check=True)
        print("================================================================================================")
        print()

        # UNCOMMENT THESE LINES BELOW TO ONLY SHOW THE DIRECTORY NAME
        # output_directory = os.getcwd()  # Get the current working directory
        # print_color(f"Download completed! Files are saved in the directory: {output_directory}", Colors.OKGREEN)

        downloaded_files = glob.glob(os.path.join(os.getcwd(), "*.*"))
        if downloaded_files:
            latest_file = max(downloaded_files, key=os.path.getctime)  # Gets the latest file by creation time
            print_color(f"Download completed! File saved to: {latest_file}", Colors.OKGREEN)
        else:
            print_color("Download completed, but the output file could not be located.", Colors.WARNING)

        print()
    except subprocess.CalledProcessError:
        print_color("Download failed. Please check the link and try again.", Colors.FAIL)
        sys.exit(1)

if __name__ == "__main__":
    print()
    print_color("YouTube Video Downloader Script", Colors.BOLD)

    # Step 1: Get YouTube video link from the user
    print()
    youtube_link = input(f"{Colors.OKCYAN}Enter a YouTube video link: {Colors.ENDC}").strip()

    # Step 2: Validate YouTube link
    print()
    is_valid_youtube_link(youtube_link)

    # Step 3: Check and setup yt-dlp
    print()
    check_yt_dlp()

    # Step 4: Fetch available formats
    print()
    formats = fetch_formats(youtube_link)

    # Step 5: Select best video and audio formats
    print()
    video_format_id, audio_format_id = select_formats(formats)

    # Step 6: Download video
    print()
    download_video(youtube_link, video_format_id, audio_format_id)
