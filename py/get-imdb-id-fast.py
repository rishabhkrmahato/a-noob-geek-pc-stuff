# IMDb Clipboard Monitor Script
# --------------------------------------------
# This script monitors your clipboard for IMDb links.
# When it detects an IMDb link, it extracts the IMDb ID (e.g., "tt1234567").
# The ID is either:
# 1. Automatically copied to your clipboard, so you can paste it directly.
# 2. Displayed in the terminal for reference.
#
# Requirements:
# - Python 3.x
# - Install the 'pyperclip' library: pip install pyperclip
#
# Usage:
# Run this script in the background while working with IMDb links.
# Copy an IMDb link, and the script will process it automatically.

import pyperclip
import re
import time

# Regex to match IMDb links and extract the ID
imdb_regex = r"https?://www\.imdb\.com/title/(tt\d+)/"

# To store the last clipboard content to avoid repetition
last_clipboard = ""

print("Monitoring clipboard for IMDb links... Press Ctrl+C to stop.")

try:
    while True:
        # Get the current clipboard content
        clipboard_content = pyperclip.paste()

        # Check if it's a new clipboard content
        if clipboard_content != last_clipboard:
            last_clipboard = clipboard_content  # Update the last clipboard

            # Check if the clipboard content matches an IMDb link
            match = re.search(imdb_regex, clipboard_content)
            if match:
                imdb_id = match.group(1)  # Extract the IMDb ID
                print(f"Detected IMDb Link: {clipboard_content}")
                print(f"IMDb ID: {imdb_id}")

                # Update the clipboard with the IMDb ID
                pyperclip.copy(imdb_id)
                # comment out line above if you don't want it replaced in clipboard.
               #print(imdb_id) 
                # uncomment line above to print it to the terminal instead.
                print("IMDb ID copied to clipboard! Now you can paste it directly.")
            else:
                # Optional: Ignore non-IMDb links
                print("No IMDb link detected. Waiting for next clipboard content...")

        # Add a small delay to avoid high CPU usage
        time.sleep(1)

except KeyboardInterrupt:
    print("\nStopped monitoring clipboard. Goodbye!")

# EG. USAGE: (in the same directory)
# py get-imdb-id-fast.py (run)
# (output below)
# Monitoring clipboard for IMDb links... Press Ctrl+C to stop.
# No IMDb link detected. Waiting for next clipboard content...
# No IMDb link detected. Waiting for next clipboard content...
# Detected IMDb Link: https://www.imdb.com/title/tt10251286/?ref_=ttep_ep1
# IMDb ID: tt10251286
# and so on ...
