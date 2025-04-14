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
  Uses colorama for proper color display on Windows terminals.

 Key Features:
  - Validates YouTube video/playlist links.
  - Guides the user to install/update dependencies if missing (Python modules, yt-dlp).
  - Fetches video information using yt-dlp's JSON output for robustness.
  - Selects highest TBR video-only and highest TBR non-DRC audio-only formats.
  - Downloads and merges the selected formats for each video.
  - Handles playlists: processes each video individually, skipping failures.
  - Saves files to the script's current directory.
  - Color-coded terminal output for clarity (works on Windows cmd/ps via colorama).

 Usage:
  1. Ensure Python 3.x is installed.
  2. Run the script: python your_script_name.py
  3. Follow on-screen prompts to install 'requests', 'packaging', and 'colorama' if needed.
  4. Ensure 'yt-dlp' is installed and accessible in your system's PATH.
     (The script will guide you if it's missing or potentially outdated).
  5. Enter a YouTube video or playlist link when prompted.

 Dependencies (Manual Setup Required - Script will guide you):
  - Python 3.x
  - yt-dlp: The core download tool. (https://github.com/yt-dlp/yt-dlp)
  - requests: For checking yt-dlp version online. (`pip install requests`)
  - packaging: For comparing versions. (`pip install packaging`)
  - colorama: For cross-platform terminal color support. (`pip install colorama`)

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

# ADDED: Check for colorama
try:
    import colorama
except ImportError:
    print("\nError: 'colorama' module not found.")
    print("This module is needed for colored output on Windows cmd/PowerShell.")
    print("Please install it by running: pip install colorama")
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
        # Force utf-8 encoding for Windows compatibility with subprocess text mode
        result = subprocess.run(['yt-dlp', '--version'], capture_output=True, text=True, check=True, encoding='utf-8', errors='ignore')
        current_ver_str = result.stdout.strip()
        print_color(f"Installed yt-dlp version: {current_ver_str}", Colors.OKBLUE)

        # Compare with latest version from GitHub API
        try:
            response = requests.get("https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest", timeout=10) # Increased timeout slightly
            response.raise_for_status() # Raise an exception for bad status codes
            latest_ver_str = response.json()["tag_name"]

            # Use packaging.version for robust comparison
            if version.parse(current_ver_str) < version.parse(latest_ver_str):
                print_color(f"Warning: Your yt-dlp version ({current_ver_str}) is outdated. Latest is {latest_ver_str}.", Colors.WARNING)
                print("It's recommended to update for the latest features and fixes:")
                print("  - Using pip: pip install --upgrade yt-dlp")
                print("  - Or download the newest version from GitHub.")
            else:
                print_color("yt-dlp is up-to-date!", Colors.OKGREEN)

        except requests.exceptions.RequestException as e:
            print_color(f"Warning: Could not check for latest yt-dlp version. {e}", Colors.WARNING)
        except Exception as e: # Catch potential JSON errors or other issues
            print_color(f"Warning: Error processing latest yt-dlp version info. {e}", Colors.WARNING)

    except subprocess.CalledProcessError as e:
        print_color(f"Error: Failed to get yt-dlp version. Command failed: {e}", Colors.FAIL)
        print(f"Stderr: {e.stderr.strip() if e.stderr else 'N/A'}")
        print("Ensure yt-dlp is installed correctly and working.")
        sys.exit(1)
    except FileNotFoundError:
         print_color("Error: 'yt-dlp' command not found even after shutil.which check. Ensure PATH is correct.", Colors.FAIL)
         sys.exit(1)
    except Exception as e: # Catch unexpected errors during version check
        print_color(f"An unexpected error occurred during yt-dlp version check: {e}", Colors.FAIL)
        sys.exit(1)


def fetch_video_info(link):
    """Fetches video metadata using yt-dlp --dump-json."""
    print_color("Fetching video info using yt-dlp...", Colors.OKBLUE)
    command = ['yt-dlp', '--dump-json', link]
    try:
        # Force utf-8 encoding for Windows compatibility
        result = subprocess.run(command, capture_output=True, text=True, check=True, encoding='utf-8', errors='ignore')
        # Handle potential empty output before JSON decoding
        if not result.stdout.strip():
             print_color(f"Error: yt-dlp returned empty output for {link}.", Colors.FAIL)
             return None
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print_color(f"Error fetching video info for {link}.", Colors.FAIL)
        # Decode stderr safely
        stderr_output = e.stderr.strip() if e.stderr else "No stderr output."
        print(f"yt-dlp command failed:\n{stderr_output}")
        return None # Signal failure
    except json.JSONDecodeError as e:
        print_color(f"Error decoding yt-dlp JSON output for {link}: {e}", Colors.FAIL)
        # Optionally print the problematic output (first ~500 chars)
        # print(f"Problematic output (start): {result.stdout[:500] if 'result' in locals() else 'N/A'}")
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
    max_video_tbr = -1  # Use -1 to handle formats with tbr=None or tbr=0
    max_audio_tbr = -1

    for fmt in formats:
        # Ensure 'tbr', 'vcodec', 'acodec' exist, provide defaults if not
        tbr = fmt.get('tbr')  # Total bitrate (might be None)
        vcodec = fmt.get('vcodec', 'none')
        acodec = fmt.get('acodec', 'none')
        format_note = fmt.get('format_note', '').lower()
        format_str = fmt.get('format', '').lower() # Fallback check in format string
        format_id = fmt.get('format_id') # Need the ID

        # Skip if format_id is missing (shouldn't happen often, but good practice)
        if not format_id:
            continue

        # Convert tbr to float, treat None as -1 for comparison
        current_tbr = -1.0
        if tbr is not None:
            try:
                current_tbr = float(tbr)
            except (ValueError, TypeError):
                current_tbr = -1.0 # Ignore if tbr is not a valid number

        # Select Video-only format (vcodec is not none, acodec is none)
        if vcodec != 'none' and acodec == 'none':
            if current_tbr > max_video_tbr:
                max_video_tbr = current_tbr
                best_video_id = format_id

        # Select Audio-only format (acodec is not none, vcodec is none, non-DRC)
        elif acodec != 'none' and vcodec == 'none':
            # Check for DRC in format_note or format string
            is_drc = 'drc' in format_note or 'drc' in format_str
            if not is_drc and current_tbr > max_audio_tbr:
                max_audio_tbr = current_tbr
                best_audio_id = format_id

    if not best_video_id:
        # Fallback: Try finding *any* video format if no video-only found
        # This might happen with older videos or unusual formats
        print_color("Warning: Could not find a video-only format. Looking for best format with video...", Colors.WARNING)
        max_video_tbr = -1 # Reset search
        for fmt in formats:
            tbr = fmt.get('tbr')
            vcodec = fmt.get('vcodec', 'none')
            format_id = fmt.get('format_id')
            if not format_id or vcodec == 'none': continue
            current_tbr = -1.0
        if tbr is not None:
            try:
                current_tbr = float(tbr)
            except (ValueError, TypeError): # Be specific or just use 'except:'
                pass # Or set current_tbr = -1.0 here too
        # The rest of the if block stays the same
        if current_tbr > max_video_tbr:
            max_video_tbr = current_tbr
            best_video_id = format_id
        if not best_video_id:
            raise FormatSelectionError("Could not find any suitable video format.")

    if not best_audio_id:
         # Fallback: Try finding *any* audio format if no non-DRC audio-only found
        print_color("Warning: Could not find a non-DRC audio-only format. Looking for best audio-only format...", Colors.WARNING)
        max_audio_tbr = -1 # Reset search
        for fmt in formats:
            tbr = fmt.get('tbr')
            acodec = fmt.get('acodec', 'none')
            vcodec = fmt.get('vcodec', 'none')
            format_id = fmt.get('format_id')
            if not format_id or acodec == 'none' or vcodec != 'none': continue # Must be audio only
            current_tbr = -1.0
        if tbr is not None:
            try:
                current_tbr = float(tbr)
            except (ValueError, TypeError): # Be specific or just use 'except:'
                pass # Or set current_tbr = -1.0 here too
        # The rest of the if block stays the same
        if current_tbr > max_audio_tbr:
            max_audio_tbr = current_tbr
            best_audio_id = format_id
        if not best_audio_id:
            raise FormatSelectionError("Could not find any suitable audio-only format.")


    print_color(f"Selected Video ID: {best_video_id} (TBR: {max_video_tbr:.2f}k)" if max_video_tbr != -1 else f"Selected Video ID: {best_video_id}", Colors.OKGREEN)
    print_color(f"Selected Audio ID: {best_audio_id} (TBR: {max_audio_tbr:.2f}k)" if max_audio_tbr != -1 else f"Selected Audio ID: {best_audio_id}", Colors.OKGREEN)
    return best_video_id, best_audio_id

def download_video(link, video_id, audio_id, output_dir):
    """Downloads and merges the selected video and audio streams."""
    print_color(f"Starting download for {link}...", Colors.HEADER)
    # Use video ID in template for potential uniqueness if titles clash
    # Ensure output dir exists
    os.makedirs(output_dir, exist_ok=True)
    # Sanitize title for filesystem compatibility (basic example)
    # A more robust library like 'pathvalidate' could be used for complex cases
    output_template = os.path.join(output_dir, '%(title)s [%(id)s].%(ext)s')
    format_string = f"{video_id}+{audio_id}"
    # Add --force-overwrites or --no-overwrites based on preference? Default overwrites partials.
    # Add --merge-output-format mp4/mkv ? Default is often mkv. Explicitly set if needed.
    command = ['yt-dlp',
               '-f', format_string,
               '-o', output_template,
               '--merge-output-format', 'mp4', # Example: Force mp4 merge
               link]

    try:
        # Run without check=True to analyze output even on failure (stderr often has info)
        # Force utf-8 encoding for Windows compatibility
        result = subprocess.run(command, capture_output=True, text=True, encoding='utf-8', errors='ignore')

        output_log = result.stdout + "\n" + result.stderr # Combine stdout and stderr for parsing

        # Print yt-dlp output for user feedback during download
        print(output_log.strip()) # Print the captured output

        # Check return code *after* running and printing output
        if result.returncode != 0:
            # Raise error to be caught by the main loop's handler
            # Include decoded output in the exception
            raise subprocess.CalledProcessError(result.returncode, command, output=result.stdout, stderr=result.stderr)

        # --- Try to find the final filename from yt-dlp's output (more robustly) ---
        final_filename = None
        # Order matters: check merge first, then fixup, then destination/already downloaded
        patterns = [
            r"\[Merger\] Merging formats into \"(.+)\"",
            r"\[Fixup\w+\] Fixing M(PEG|KV)TS in \"(.+)\"", # More specific fixups
            r"\[Fixup\w+\] Fixing.* in \"(.+)\"", # Generic fixup
            r"\[download\] Destination: (.+)",
            r"\[download\] (.+) has already been downloaded"
        ]

        for pattern in patterns:
            match = re.search(pattern, output_log)
            if match:
                # Group 1 usually contains the path in quotes/after destination
                # Group 2 for the FixupM*TS pattern
                potential_path = match.group(match.lastindex or 1)
                # Basic check if the path looks reasonable (e.g., contains the video ID from template)
                video_id_in_path = re.search(r"\[([a-zA-Z0-9_-]{11})\]", potential_path)
                if video_id_in_path: # or just check if os.path.exists(potential_path): # Less reliable right after process ends
                    final_filename = potential_path
                    break # Found a likely candidate

        if final_filename:
            # Ensure the path is absolute only if it's not already (yt-dlp usually gives abs path)
            if not os.path.isabs(final_filename):
                final_filename = os.path.abspath(os.path.join(output_dir, os.path.basename(final_filename)))

            # Double check existence for confirmation
            if os.path.exists(final_filename):
                 print_color(f"Download and merge successful! Final file:", Colors.OKGREEN)
                 print(f"{final_filename}")
            else:
                 print_color(f"Download process finished, but couldn't verify final file location: {final_filename}", Colors.WARNING)
                 print(f"Check your output directory: {output_dir}")

        else:
            # Check if *any* file matching the pattern exists as a last resort
            potential_files = []
            try:
                # Extract expected ID and title elements if possible
                # This part is complex; a simpler check is just to list the dir
                print_color("Download process finished, but couldn't parse exact filename from output.", Colors.WARNING)
                print(f"Please check your output directory for the downloaded file: {output_dir}")

            except Exception as e:
                print_color(f"Error during fallback file check: {e}", Colors.FAIL)


    except subprocess.CalledProcessError as e:
        # This error will be caught and handled in the main loop
        # Re-raise it to propagate the failure information including output
        raise e
    except Exception as e:
         # Catch other potential errors during download/parsing
         print_color(f"An unexpected error occurred during download process for {link}: {e}", Colors.FAIL)
         # Re-raise to be handled by the main loop
         raise e

def is_valid_youtube_link(link):
    """Validates YouTube link format and checks if it's a playlist."""
    print_color("\nValidating YouTube link...", Colors.OKBLUE)
    # Regex for various YouTube video, shorts, and playlist URL formats
    # Allows http/https, www optional, youtube.com/youtu.be domains
    # Captures video ID (group 5) and playlist ID (group 8)
    youtube_regex = re.compile(
        r'^(https?://)?(www\.)?(youtube\.com|youtu\.be)/'
        r'(watch\?v=|playlist\?list=|embed/|shorts/|live/|channel/|@)?' # Added channel/@
        r'([a-zA-Z0-9_-]{11})?' # Optional Video ID (group 5)
        r'([\?&]list=([a-zA-Z0-9_-]+))?' # Optional Playlist ID (group 7 -> actual ID is group 8)
        r'.*$', re.IGNORECASE)

    match = youtube_regex.match(link)

    if not match:
        print_color("Invalid URL format. Doesn't look like a YouTube link.", Colors.FAIL)
        return None, None # Indicate failure

    # Check for playlist parameter explicitly
    playlist_id_match = re.search(r"[?&]list=([a-zA-Z0-9_-]+)", link, re.IGNORECASE)
    is_playlist = bool(playlist_id_match)
    video_id = match.group(5) # Get potential video ID

    if is_playlist:
        print_color("Playlist link detected.", Colors.WARNING)
        while True:
            try:
                # Ask user whether to download playlist or just the single video (if present)
                prompt = f"{Colors.BOLD}Download the entire playlist? (y/n): {Colors.ENDC}"
                if video_id:
                    prompt = f"{Colors.BOLD}Link contains both video ({video_id}) and playlist ({playlist_id_match.group(1)}).\nDownload the entire playlist (y) or just this video (n)? (y/n): {Colors.ENDC}"

                user_choice = input(prompt).strip().lower()

                if user_choice == 'y':
                    print_color("Preparing to download the entire playlist...", Colors.OKGREEN)
                    # Construct a clean playlist URL
                    playlist_url = f"https://www.youtube.com/playlist?list={playlist_id_match.group(1)}"
                    return "playlist", playlist_url
                elif user_choice == 'n':
                    if video_id:
                        # User wants only the single video from the combined link
                        cleaned_url = f"https://www.youtube.com/watch?v={video_id}"
                        print_color(f"Proceeding with single video: {cleaned_url}", Colors.OKGREEN)
                        return "video", cleaned_url
                    else:
                        # Playlist link detected, but user chose 'n' and no video ID was found
                        print_color("No individual video ID found in the link to download separately.", Colors.FAIL)
                        print_color("Please provide a direct video link or choose 'y' for the playlist.", Colors.WARNING)
                        return None, None # Indicate failure to proceed
                else:
                    print_color("Invalid choice. Please enter 'y' or 'n'.", Colors.FAIL)
            except EOFError: # Handle Ctrl+D or similar unexpected EOF
                print_color("\nOperation cancelled by user.", Colors.FAIL)
                return None, None
    elif video_id or '/live/' in link: # Check if video ID exists or it's a /live/ link
         print_color("YouTube video/live link appears valid!", Colors.OKGREEN)
         # Return the original link as it's confirmed to be a video/live type
         return "video", link
    else:
        # Matches base youtube.com/youtu.be but no video/playlist/live recognized
        print_color("Link is for YouTube, but doesn't seem to be a video, playlist, or live stream.", Colors.FAIL)
        print_color("Channel/user links are not directly downloadable with this script's focus.", Colors.WARNING)
        return None, None


def get_playlist_videos(playlist_url):
    """Extracts all video URLs from a playlist using yt-dlp."""
    print_color("\nExtracting video links from the playlist...", Colors.HEADER)
    # Use --print URL to get URLs directly
    command = ['yt-dlp', '--flat-playlist', '--print', 'url', playlist_url]
    try:
        # Force utf-8 encoding for Windows compatibility
        result = subprocess.run(command, capture_output=True, text=True, check=True, encoding='utf-8', errors='ignore')
        video_links = result.stdout.strip().splitlines()
        # Filter out potential empty lines
        video_links = [link for link in video_links if link.strip()]

        if not video_links:
            print_color("No video links found in the playlist or failed to extract.", Colors.WARNING)
            # Check stderr for clues
            if result.stderr.strip():
                 print(f"{Colors.WARNING}yt-dlp Output:\n{result.stderr.strip()}{Colors.ENDC}")
            return [] # Return empty list, don't exit

        print_color(f"Found {len(video_links)} videos in the playlist.", Colors.OKGREEN)
        return video_links

    except subprocess.CalledProcessError as e:
        print_color("Error extracting videos from playlist.", Colors.FAIL)
        stderr_output = e.stderr.strip() if e.stderr else "No stderr output."
        print(f"yt-dlp command failed:\n{stderr_output}")
        return [] # Return empty list on error
    except Exception as e:
        print_color(f"An unexpected error occurred during get_playlist_videos: {e}", Colors.FAIL)
        return []

# --- Main Execution ---
if __name__ == "__main__":
    # ADDED: Initialize colorama for cross-platform color support
    colorama.init()

    print_color("\n--- Universal YouTube Downloader ---", Colors.BOLD + Colors.HEADER)

    check_prerequisites() # Check dependencies first

    youtube_link_input = "" # Initialize variable
    try:
        youtube_link_input = input(f"\n{Colors.OKCYAN}Enter a YouTube video or playlist link: {Colors.ENDC}").strip()
        if not youtube_link_input:
            print_color("No link entered. Exiting.", Colors.FAIL)
            sys.exit(1)
    except EOFError:
        print_color("\nOperation cancelled by user input.", Colors.FAIL)
        sys.exit(1)
    except KeyboardInterrupt:
         print_color("\nOperation cancelled by user (Ctrl+C).", Colors.FAIL)
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
    current_dir = os.getcwd() # Save to script's current directory

    for index, video_url in enumerate(video_links_to_download, start=1):
        print("\n" + "="*70)
        print_color(f"Processing Video {index}/{total_videos}: {video_url}", Colors.BOLD + Colors.OKCYAN)
        print("="*70)

        try:
            # 1. Fetch video info
            video_info = fetch_video_info(video_url)
            if video_info is None:
                raise Exception("Failed to fetch video information.") # Generic error to be caught below

            # Extract title for potential error messages before format selection
            video_title = video_info.get('title', 'Unknown Title')
            print_color(f"Title: {video_title}", Colors.OKBLUE)


            # 2. Select formats
            video_format_id, audio_format_id = select_formats(video_info)
            # select_formats raises FormatSelectionError on failure

            # 3. Download video
            download_video(video_url, video_format_id, audio_format_id, current_dir)
            # download_video raises CalledProcessError on failure

            success_count += 1

        # --- Granular Error Handling per Video ---
        except FormatSelectionError as e:
            print_color(f"Skipping video {index} ({video_title}): Could not select formats. Reason: {e}", Colors.FAIL)
            fail_count += 1
            continue # Move to the next video
        except subprocess.CalledProcessError as e:
            print_color(f"Skipping video {index} ({video_title}): Download/Merge command failed (Exit code: {e.returncode}).", Colors.FAIL)
            # Print stderr from yt-dlp for more details
            stderr_output = e.stderr.strip() if e.stderr else "No stderr output available."
            print(f"{Colors.FAIL}yt-dlp Error Output:{Colors.ENDC}\n{stderr_output}")
            fail_count += 1
            continue # Move to the next video
        except Exception as e: # Catch any other unexpected errors for this video
            print_color(f"Skipping video {index} ({video_title}): An unexpected error occurred: {e}", Colors.FAIL)
            # Optional: Print traceback for debugging complex issues
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
    print(f"Files should be saved in directory: {current_dir}")
    print("="*70 + "\n")

    # ADDED: Deinitialize colorama (optional, good practice)
    colorama.deinit()