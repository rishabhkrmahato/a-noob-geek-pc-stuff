# -*- coding: utf-8 -*-
"""
==============================================================================
 Universal YouTube Downloader (Video & Playlist)
==============================================================================
 Description:
   Downloads YouTube videos or entire playlists using yt-dlp.
   It focuses on selecting the best quality video and audio streams based
   on bitrate (TBR), ensuring audio streams are not Dynamic Range Compressed (DRC).
   Designed to be cross-platform (Windows, macOS, Linux, Termux).

 Key Features:
   - Validates YouTube video/playlist links.
   - Guides the user to install/update dependencies if missing (Python modules, yt-dlp).
   - Fetches video information using yt-dlp's JSON output for robustness.
   - Selects highest TBR video-only and highest TBR non-DRC audio-only formats.
   - Downloads and merges the selected formats for each video.
   - Handles playlists: processes each video individually, skipping failures.
   - Saves files to the script's current directory.
   - Color-coded terminal output for clarity.

 Usage:
   1. Ensure Python 3.x is installed.
   2. Run the script: python your_script_name.py
   3. Follow on-screen prompts to install 'requests' and 'packaging' if needed.
   4. Ensure 'yt-dlp' is installed and accessible in your system's PATH.
      (The script will guide you if it's missing or potentially outdated).
   5. Enter a YouTube video or playlist link when prompted.

 Dependencies (Manual Setup Required - Script will guide you):
   - Python 3.x
   - yt-dlp: The core download tool. (https://github.com/yt-dlp/yt-dlp)
   - requests: For checking yt-dlp version online. (`pip install requests`)
   - packaging: For comparing versions. (`pip install packaging`)

 Notes:
   - Requires an active internet connection.
   - Does NOT automatically install or update dependencies. Follow the
     on-screen instructions if prompted.
   - Format selection prioritizes highest Total Bit Rate (TBR) for video
     and non-DRC audio, which usually correlates with quality.
==============================================================================
"""

import os
import sys
import subprocess
import re
import json
import shutil  # Used instead of 'which' for Python 3.3+

# --- Configuration ---
# Current Date (example, could be used for logging if needed)
# CURRENT_DATE_STR = datetime.datetime.now().strftime("%Y-%m-%d")

# --- Dependency Checks ---
try:
    import requests
except ImportError:
    print("\nError: 'requests' module not found.")
    print("Please install it by running: pip install requests")
    sys.exit(1)

try:
    from packaging import version
except ImportError:
    print("\nError: 'packaging' module not found.")
    print("Please install it by running: pip install packaging")
    sys.exit(1)


# --- Colors for terminal output ---
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def print_color(message, color):
    """Prints a message in a specified color."""
    print(f"{color}{message}{Colors.ENDC}")

# --- Custom Exception ---
class FormatSelectionError(Exception):
    """Custom exception for errors during format selection."""
    pass

# --- Core Functions ---

def check_prerequisites():
    """Checks for yt-dlp installation and version."""
    print_color("\nChecking prerequisites...", Colors.HEADER)

    # 1. Check for yt-dlp command
    yt_dlp_path = shutil.which("yt-dlp")
    if yt_dlp_path is None:
        print_color("Error: 'yt-dlp' command not found in your system's PATH.", Colors.FAIL)
        print("Please install yt-dlp.")
        print("  - Using pip (recommended): pip install --upgrade yt-dlp")
        print("  - Or download from GitHub: https://github.com/yt-dlp/yt-dlp#installation")
        sys.exit(1)
    else:
        print_color(f"yt-dlp found at: {yt_dlp_path}", Colors.OKGREEN)

    # 2. Check yt-dlp version (optional but recommended)
    try:
        result = subprocess.run(['yt-dlp', '--version'], capture_output=True, text=True, check=True, encoding='utf-8')
        current_ver_str = result.stdout.strip()
        print_color(f"Installed yt-dlp version: {current_ver_str}", Colors.OKBLUE)

        # Compare with latest version from GitHub API
        try:
            response = requests.get("https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest", timeout=5)
            response.raise_for_status() # Raise an exception for bad status codes
            latest_ver_str = response.json()["tag_name"]

            if version.parse(current_ver_str) < version.parse(latest_ver_str):
                print_color(f"Warning: Your yt-dlp version ({current_ver_str}) is outdated. Latest is {latest_ver_str}.", Colors.WARNING)
                print("It's recommended to update for the latest features and fixes:")
                print("  - Using pip: pip install --upgrade yt-dlp")
                print("  - Or download the newest version from GitHub.")
            else:
                print_color("yt-dlp is up-to-date!", Colors.OKGREEN)

        except requests.exceptions.RequestException as e:
            print_color(f"Warning: Could not check for latest yt-dlp version. {e}", Colors.WARNING)
        except Exception as e:
             print_color(f"Warning: Error processing latest yt-dlp version info. {e}", Colors.WARNING)

    except subprocess.CalledProcessError as e:
        print_color(f"Error: Failed to get yt-dlp version. Command failed: {e}", Colors.FAIL)
        print("Ensure yt-dlp is installed correctly and working.")
        sys.exit(1)
    except FileNotFoundError:
         print_color("Error: 'yt-dlp' command not found even after shutil.which check. Ensure PATH is correct.", Colors.FAIL)
         sys.exit(1)

def fetch_video_info(link):
    """Fetches video metadata using yt-dlp --dump-json."""
    print_color("Fetching video info using yt-dlp...", Colors.OKBLUE)
    command = ['yt-dlp', '--dump-json', link]
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True, encoding='utf-8', errors='ignore')
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print_color(f"Error fetching video info for {link}.", Colors.FAIL)
        print(f"yt-dlp command failed:\n{e.stderr}")
        return None # Signal failure
    except json.JSONDecodeError as e:
        print_color(f"Error decoding yt-dlp JSON output for {link}: {e}", Colors.FAIL)
        return None # Signal failure
    except Exception as e:
        print_color(f"An unexpected error occurred during fetch_video_info for {link}: {e}", Colors.FAIL)
        return None

def select_formats(video_info):
    """Parses JSON data and selects the best video and audio formats based on TBR."""
    print_color("Selecting best video/audio formats...", Colors.OKBLUE)
    if not video_info or 'formats' not in video_info:
        raise FormatSelectionError("No format information available in video data.")

    formats = video_info['formats']
    best_video_id = None
    best_audio_id = None
    max_video_tbr = -1  # Use -1 to handle formats with tbr=0
    max_audio_tbr = -1

    for fmt in formats:
        # Ensure 'tbr', 'vcodec', 'acodec' exist, provide defaults if not
        tbr = fmt.get('tbr')  # Total bitrate (might be None)
        vcodec = fmt.get('vcodec', 'none')
        acodec = fmt.get('acodec', 'none')
        format_note = fmt.get('format_note', '').lower()
        format_str = fmt.get('format', '').lower() # Fallback check in format string

        # Convert tbr to float, treat None as -1 for comparison
        current_tbr = -1
        if tbr is not None:
            try:
                current_tbr = float(tbr)
            except (ValueError, TypeError):
                current_tbr = -1 # Ignore if tbr is not a valid number

        # Select Video-only format
        if vcodec != 'none' and acodec == 'none':
            if current_tbr > max_video_tbr:
                max_video_tbr = current_tbr
                best_video_id = fmt.get('format_id')

        # Select Audio-only format (non-DRC)
        elif acodec != 'none' and vcodec == 'none':
            # Check for DRC in format_note or format string
            is_drc = 'drc' in format_note or 'drc' in format_str
            if not is_drc and current_tbr > max_audio_tbr:
                max_audio_tbr = current_tbr
                best_audio_id = fmt.get('format_id')

    if not best_video_id:
        raise FormatSelectionError("Could not find a suitable video-only format.")
    if not best_audio_id:
        raise FormatSelectionError("Could not find a suitable non-DRC audio-only format.")

    print_color(f"Selected Video ID: {best_video_id} (TBR: {max_video_tbr:.2f}k)" if max_video_tbr != -1 else f"Selected Video ID: {best_video_id}", Colors.OKGREEN)
    print_color(f"Selected Audio ID: {best_audio_id} (TBR: {max_audio_tbr:.2f}k)" if max_audio_tbr != -1 else f"Selected Audio ID: {best_audio_id}", Colors.OKGREEN)
    return best_video_id, best_audio_id

def download_video(link, video_id, audio_id, output_dir):
    """Downloads and merges the selected video and audio streams."""
    print_color(f"Starting download for {link}...", Colors.HEADER)
    # Use video ID in template for potential uniqueness if titles clash
    output_template = os.path.join(output_dir, '%(title)s [%(id)s].%(ext)s')
    format_string = f"{video_id}+{audio_id}"
    command = ['yt-dlp', '-f', format_string, '-o', output_template, link]

    try:
        # Run without check=True to analyze output even on failure (stderr often has info)
        result = subprocess.run(command, capture_output=True, text=True, encoding='utf-8', errors='ignore')

        output_log = result.stdout + "\n" + result.stderr # Combine stdout and stderr for parsing

        # Check return code *after* running
        if result.returncode != 0:
            # Raise error to be caught by the main loop's handler
            raise subprocess.CalledProcessError(result.returncode, command, output=result.stdout, stderr=result.stderr)

        # --- Try to find the final filename from yt-dlp's output ---
        final_filename = None
        # Regex for '[Merger] Merging formats into "..."' or '[download] Destination: ...'
        # It captures the filename inside the quotes or after "Destination: "
        # Handles filenames with spaces correctly if quoted.
        merge_match = re.search(r"\[Merger\] Merging formats into \"(.+)\"", output_log)
        dest_match = re.search(r"\[download\] Destination: (.+)", output_log)
        # Regex for cases where yt-dlp just downloads (e.g., mp4 already exists)
        downloaded_match = re.search(r"\[download\] (.+) has already been downloaded", output_log)
        ffmpeg_match = re.search(r"\[FixupM3u8\] Fixing MPEG-TS in \"(.+)\"", output_log) # M3U8 Fixup
        ffmpeg_generic_match = re.search(r"\[Fixup\w+\] Fixing.* in \"(.+)\"", output_log) # More generic fixup

        if merge_match:
            final_filename = merge_match.group(1)
        elif dest_match:
             # Need to check if it was later merged - Merger message is more reliable for final name
            temp_filename = dest_match.group(1)
            # Check if a *later* merge message exists for *this specific base name*
            # This is tricky, rely on merge_match if possible. Assume dest_match is final if no merge_match.
            final_filename = temp_filename
            # Refine check: see if output indicates merging happened AFTER this destination message
            dest_pos = output_log.find(f"[download] Destination: {temp_filename}")
            merge_later = "[Merger] Merging formats into" in output_log[dest_pos:] if dest_pos != -1 else False
            if merge_later:
                 final_filename = None # Wait for merge message parsing
            else:
                 final_filename = temp_filename
        elif downloaded_match:
             final_filename = downloaded_match.group(1)
        elif ffmpeg_match:
             final_filename = ffmpeg_match.group(1)
        elif ffmpeg_generic_match:
             final_filename = ffmpeg_generic_match.group(1)

        if final_filename:
            # Ensure the path is absolute if it's not already
            if not os.path.isabs(final_filename):
                 final_filename = os.path.join(output_dir, os.path.basename(final_filename)) # Use basename just in case
            print_color(f"Download successful! File saved to:", Colors.OKGREEN)
            print(f"{final_filename}")

        else:
            print_color("Download likely completed, but couldn't parse exact filename from output.", Colors.OKGREEN)
            print(f"Check your output directory for a file matching the pattern: {output_template}")
            # Fallback: list recent files? Maybe too complex/unreliable. Stick to pattern.

    except subprocess.CalledProcessError as e:
        # This error will be caught and handled in the main loop
        # Re-raise it to propagate the failure information
        raise e
    except Exception as e:
         # Catch other potential errors during download/parsing
         print_color(f"An unexpected error occurred during download for {link}: {e}", Colors.FAIL)
         # Re-raise to be handled by the main loop
         raise e

def is_valid_youtube_link(link):
    """Validates YouTube link format and checks if it's a playlist."""
    print_color("\nValidating YouTube link...", Colors.OKBLUE)
    # Regex for various YouTube video, shorts, and playlist URL formats
    youtube_regex = re.compile(
        r'^(https?://)?(www\.)?(youtube\.com|youtu\.be)/'
        r'(watch\?v=|playlist\?list=|embed/|shorts/|live/)?'
        r'([a-zA-Z0-9_-]{11})?' # Optional Video ID
        r'([\?&]list=([a-zA-Z0-9_-]+))?' # Optional Playlist ID
        r'.*$', re.IGNORECASE)

    match = youtube_regex.match(link)

    if not match:
        print_color("Invalid YouTube URL format.", Colors.FAIL)
        return None, None # Indicate failure

    # Check if 'list=' parameter is present indicating a playlist
    is_playlist = 'list=' in link

    if is_playlist:
        print_color("Playlist link detected.", Colors.WARNING)
        while True:
            try:
                user_choice = input(f"{Colors.BOLD}Download the entire playlist? (y/n): {Colors.ENDC}").strip().lower()
                if user_choice == 'y':
                    print_color("Preparing to download the entire playlist...", Colors.OKGREEN)
                    # Extract the playlist URL part (ensure only list= parameter is primary)
                    playlist_match = re.search(r"(list=([a-zA-Z0-9_-]+))", link)
                    if playlist_match:
                         playlist_url = f"https://www.youtube.com/playlist?{playlist_match.group(1)}"
                         return "playlist", playlist_url
                    else:
                         print_color("Could not cleanly extract playlist ID. Using original link.", Colors.WARNING)
                         return "playlist", link # Fallback to original link
                elif user_choice == 'n':
                     # Try to extract just the video part if present
                    video_id_match = re.search(r"v=([a-zA-Z0-9_-]{11})", link)
                    if video_id_match:
                        cleaned_url = f"https://www.youtube.com/watch?v={video_id_match.group(1)}"
                        print_color(f"Proceeding with single video: {cleaned_url}", Colors.OKGREEN)
                        return "video", cleaned_url
                    else:
                        print_color("Could not find a video ID in the playlist link to download individually.", Colors.FAIL)
                        print_color("Please provide a direct video link if you don't want the playlist.", Colors.WARNING)
                        return None, None # Indicate failure to proceed
                else:
                     print_color("Invalid choice. Please enter 'y' or 'n'.", Colors.FAIL)
            except EOFError: # Handle Ctrl+D or similar unexpected EOF
                 print_color("\nOperation cancelled by user.", Colors.FAIL)
                 return None, None
    else:
        # Validate it's likely a video/short/live link
        if not match.group(5) and '/live/' not in link: # Check if video ID group exists or it's a /live/ link
             print_color("Link does not appear to be a valid video, short, or live stream link.", Colors.FAIL)
             return None, None
        print_color("YouTube video link is valid!", Colors.OKGREEN)
        return "video", link

def get_playlist_videos(playlist_url):
    """Extracts all video URLs from a playlist using yt-dlp."""
    print_color("\nExtracting video links from the playlist...", Colors.HEADER)
    command = ['yt-dlp', '--flat-playlist', '--print', '%(webpage_url)s', playlist_url]
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True, encoding='utf-8', errors='ignore')
        video_links = result.stdout.strip().splitlines()

        if not video_links:
            print_color("No video links found in the playlist or failed to extract.", Colors.WARNING)
            return [] # Return empty list, don't exit

        print_color(f"Found {len(video_links)} videos in the playlist.", Colors.OKGREEN)
        return video_links

    except subprocess.CalledProcessError as e:
        print_color("Error extracting videos from playlist.", Colors.FAIL)
        print(f"yt-dlp command failed:\n{e.stderr}")
        return [] # Return empty list on error
    except Exception as e:
        print_color(f"An unexpected error occurred during get_playlist_videos: {e}", Colors.FAIL)
        return []

# --- Main Execution ---
if __name__ == "__main__":
    print_color("\n--- Universal YouTube Downloader ---", Colors.BOLD + Colors.HEADER)

    check_prerequisites() # Check dependencies first

    try:
         youtube_link_input = input(f"\n{Colors.OKCYAN}Enter a YouTube video or playlist link: {Colors.ENDC}").strip()
         if not youtube_link_input:
              print_color("No link entered. Exiting.", Colors.FAIL)
              sys.exit(1)
    except EOFError:
         print_color("\nOperation cancelled by user.", Colors.FAIL)
         sys.exit(1)

    link_type, url_to_process = is_valid_youtube_link(youtube_link_input)

    if link_type is None:
        sys.exit(1) # Exit if validation failed

    video_links_to_download = []
    if link_type == "video":
        video_links_to_download.append(url_to_process)
    elif link_type == "playlist":
        video_links_to_download = get_playlist_videos(url_to_process)
        if not video_links_to_download:
            print_color("No videos found in the playlist or failed to retrieve them. Exiting.", Colors.FAIL)
            sys.exit(1)

    print(f"\n{Colors.HEADER}--- Starting Download Process ---{Colors.ENDC}")
    total_videos = len(video_links_to_download)
    success_count = 0
    fail_count = 0
    current_dir = os.getcwd()

    for index, video_url in enumerate(video_links_to_download, start=1):
        print("\n" + "="*70)
        print_color(f"Processing Video {index}/{total_videos}: {video_url}", Colors.BOLD + Colors.OKCYAN)
        print("="*70)

        try:
            # 1. Fetch video info
            video_info = fetch_video_info(video_url)
            if video_info is None:
                raise Exception("Failed to fetch video information.") # Generic error to be caught below

            # 2. Select formats
            video_format_id, audio_format_id = select_formats(video_info)
            # select_formats raises FormatSelectionError on failure

            # 3. Download video
            download_video(video_url, video_format_id, audio_format_id, current_dir)
            # download_video raises CalledProcessError on failure

            success_count += 1

        # --- Granular Error Handling per Video ---
        except FormatSelectionError as e:
            print_color(f"Skipping video {index}: Could not select formats. Reason: {e}", Colors.FAIL)
            fail_count += 1
            continue # Move to the next video
        except subprocess.CalledProcessError as e:
            print_color(f"Skipping video {index}: Download command failed (Exit code: {e.returncode}).", Colors.FAIL)
            # Print stderr from yt-dlp for more details
            if e.stderr:
                print(f"{Colors.FAIL}yt-dlp Error Output:{Colors.ENDC}\n{e.stderr.strip()}")
            fail_count += 1
            continue # Move to the next video
        except Exception as e: # Catch any other unexpected errors for this video
            print_color(f"Skipping video {index}: An unexpected error occurred: {e}", Colors.FAIL)
            # Consider logging traceback here if needed for debugging
            # import traceback
            # traceback.print_exc()
            fail_count += 1
            continue # Move to the next video

    # --- Final Summary ---
    print("\n" + "="*70)
    print_color("--- Download Process Finished ---", Colors.BOLD + Colors.HEADER)
    print_color(f"Successfully downloaded: {success_count}/{total_videos}", Colors.OKGREEN)
    if fail_count > 0:
        print_color(f"Failed/Skipped videos:  {fail_count}/{total_videos}", Colors.FAIL)
    print(f"Files saved in directory: {current_dir}")
    print("="*70 + "\n")