"""
==============================================================================================

Description:

YouTube Music Multi-Search Script

This Python script automates opening multiple YouTube Music search tabs in 
Google Chrome for a list of user-provided songs. It helps streamline searching 
for songs by generating YouTube Music search URLs and opening them as browser tabs.

Key Features:
- Prompts the user to input song names, one per line.
- Opens a new Google Chrome window for searches (configurable).
- Generates YouTube Music search URLs for each song.
- Opens each search in a new tab with a delay to avoid overload.

Usage:
1. Run the script in a Python environment.
2. Enter song names one by one when prompted, and type 'done' to finish.
3. The script opens a new Chrome window and searches for each song in a separate tab.

Configurations:
- `BASE_URL`: Base URL for YouTube Music searches (default: "https://music.youtube.com/search?q=").
- `CHROME_PATH`: Command to launch Chrome (default: "start chrome"). Update if the path is non-standard.
- `NEW_WINDOW_FLAG`: Chrome flag to open a new window (default: opens Google search).
- `TAB_DELAY`: Delay (in seconds) between opening each tab (default: 2 seconds).

Steps to Update Hard-Coded Details:
1. Update `CHROME_PATH` to match your system's Chrome path, if necessary.
2. Modify `NEW_WINDOW_FLAG` to change the default behavior for opening a new Chrome window.
3. Adjust `TAB_DELAY` to control the delay between opening tabs.

Output:
- Opens a new Chrome window with YouTube Music search tabs for each entered song.

Error Handling:
- Logs any errors encountered when opening the browser or tabs.
- Exits gracefully if the user cancels the script or an unexpected error occurs.

Notes:
- Ensure Google Chrome is installed and added to the system PATH.
- Internet connectivity is required to open YouTube Music tabs.

==============================================================================================
"""


import webbrowser
import urllib.parse
import os
import time

# ------------------------
# Constants & Configurations
# ------------------------
BASE_URL = "https://music.youtube.com/search?q="  # Base URL for YouTube Music searches
CHROME_PATH = "start chrome"  # Update if Chrome's PATH is non-standard
# NEW_WINDOW_FLAG = "--new-window about:blank"  # Opens a blank Chrome window first
NEW_WINDOW_FLAG = "--new-window https://www.google.com"
# NEW_WINDOW_FLAG = "--new-window"
TAB_DELAY = 2  # Delay (in seconds) between opening each tab

# ------------------------
# Function: Open a New Chrome Window
# ------------------------
def open_new_chrome_window():
    """
    Opens a new Chrome browser window.
    Returns:
        bool: True if the window was opened successfully, False otherwise.
    """
    try:
        os.system(f"{CHROME_PATH} {NEW_WINDOW_FLAG}")
        time.sleep(1)  # Allow the new window to initialize
        print("\n🆕 A new Chrome window has been opened successfully!")
        return True
    except Exception as e:
        print(f"\n❌ Failed to open a new Chrome window: {e}")
        return False

# ------------------------
# Function: Get Search Terms from User
# ------------------------
def get_search_terms():
    """
    Prompts the user to enter song names one per line.
    Returns:
        list: A list of song names entered by the user.
    """
    print("\n🎵 Enter the songs to search or paste a long list (one per line). Type 'done' when finished:")
    songs = []
    while True:
        song = input("🎧 > ").strip()
        if song.lower() == "done":
            break
        if song:  # Ignore empty inputs
            songs.append(song)
    return songs

# ------------------------
# Function: Open YouTube Music Tabs
# ------------------------
def open_youtube_music_tabs(songs):
    """
    Opens YouTube Music search tabs for a list of songs.
    Args:
        songs (list): List of song names to search.
    """
    print("\n🔎 Starting to open search tabs...")
    for song in songs:
        # Generate the search URL
        search_url = BASE_URL + urllib.parse.quote(song)
        print(f"🌐 Opening: {search_url}")  # Log the URL being opened
        
        # Open the search URL in a new tab
        webbrowser.open_new_tab(search_url)
        time.sleep(TAB_DELAY)  # Pause before opening the next tab
    print("\n✅ All search tabs have been opened successfully!")

# ------------------------
# Main Function
# ------------------------
def main():
    """
    Main script logic to get user input, open a new Chrome window,
    and search for songs on YouTube Music.
    """
    print("\n======================================")
    print("🎶 YouTube Music Multi-Search Script 🎶")
    print("======================================\n")

    # Step 1: Get songs from the user
    songs = get_search_terms()
    if not songs:
        print("\n⚠️ No songs provided. Exiting the script.")
        return

    # Step 2: Open a new Chrome window
    if not open_new_chrome_window():
        print("\n⚠️ Unable to open a new Chrome window. Exiting the script.")
        return

    # Step 3: Open search tabs for each song
    open_youtube_music_tabs(songs)

    # End of script
    print("\n🎉 Thank you for using YouTube Music Multi-Search! Goodbye!")

# ------------------------
# Entry Point
# ------------------------
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n❌ Script interrupted by the user. Exiting.")
    except Exception as e:
        print(f"\n❌ An unexpected error occurred: {e}")
