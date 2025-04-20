#!/usr/bin/env bash

# --- Header Start ---
# Title: Quick yt-dlp Setup for Termux
# Desc: Installs/Updates yt-dlp, Python, FFmpeg, and configures the 'ydl' command.
# Prerequisite: Run 'termux-setup-storage' FIRST & grant storage permission.
# Usage: Run this script once: bash your-script-name.sh 
#        [or make it executable *if needed* (chmod +x scriptname.sh)]
#        Then use: ydl <video_url>
# Output: Videos saved to /storage/emulated/0/Download/
# Update yt-dlp: yt-dlp -U
# --- Header End ---

echo "--- Starting yt-dlp setup for Termux ---"
echo

# --- Improvement: Add a prominent warning about storage permission ---
echo "[!!! IMPORTANT !!!]"
echo "This script needs Termux to have Storage Permission."
echo "If you haven't already, run 'termux-setup-storage' and grant permission when Android asks."
echo "Downloads will fail without this permission."
echo "[!!! IMPORTANT !!!]"
echo

# --- Update & Upgrade Termux Packages ---
echo "--> Updating Termux package lists..."
# --- Improvement: Added basic error checking ---
pkg update -y || { echo "[ERROR] 'pkg update' failed. Check internet connection or Termux repositories. Aborting."; exit 1; }
echo
echo "--> Upgrading installed packages..."
# --- Improvement: Added warning on failure (less critical than update/install) ---
pkg upgrade -y || echo "[WARNING] 'pkg upgrade' failed. Consider running manually later."
echo

# --- Install Dependencies ---
echo "--> Installing Python (required for yt-dlp)..."
pkg install python -y || { echo "[ERROR] Failed to install Python. Aborting."; exit 1; }
# --- Improvement: Check if pip command exists after python install ---
if ! command -v pip > /dev/null; then
    echo "[ERROR] 'pip' command not found after Python installation. Aborting."
    exit 1
fi
echo
echo "--> Installing FFmpeg (required for merging formats)..."
pkg install ffmpeg -y || { echo "[ERROR] Failed to install FFmpeg. Merging audio/video might fail. Aborting."; exit 1; }
echo

# --- Install/Update yt-dlp ---
echo "--> Installing/Updating yt-dlp using pip..."
# --- Improvement: Use --upgrade to get the latest version or install if missing ---
pip install --upgrade yt-dlp || { echo "[ERROR] Failed to install/update yt-dlp using pip. Aborting."; exit 1; }
echo

# --- Configure Alias in .bashrc ---
echo "--> Configuring 'ydl' alias in ~/.bashrc..."

# --- Update: Define the new alias command string ---
# Note the escaped inner double quotes (\") needed because the alias itself is in double quotes.
# Format: Best video without audio + best audio without video (excluding Dolby Vision/DRC if possible), fallback to best video+audio combined.
ALIAS_CMD="alias ydl=\"yt-dlp -f \\\"bv[acodec=none]+ba[vcodec=none][format_note!*=DRC]/bv[acodec=none]+ba[vcodec=none]/b\\\" -o '/storage/emulated/0/Download/%(title)s.%(ext)s'\""
ALIAS_COMMENT="# Alias for yt-dlp: best separate video/audio (no DRC), fallback best combined"

# --- Improvement: Check if alias already exists to prevent duplicates ---
BASHRC_FILE="$HOME/.bashrc"
if grep -qF "$ALIAS_CMD" "$BASHRC_FILE"; then
    echo "   Alias 'ydl' with the specific command already exists in $BASHRC_FILE. Skipping add."
elif grep -qF "alias ydl=" "$BASHRC_FILE"; then
    echo "   An alias named 'ydl' already exists but differs. Check your $BASHRC_FILE manually."
    echo "   Skipping automatic addition to prevent conflicts."
else
    echo "   Adding alias to $BASHRC_FILE..."
    # Add a newline ensure alias is on a new line, then add comment and alias
    {
      echo "" # Add blank line before alias section
      echo "$ALIAS_COMMENT"
      echo "$ALIAS_CMD"
    } >> "$BASHRC_FILE"
    echo "   Alias added."
fi
echo

# --- Apply changes to the current session ---
echo "--> Applying changes to current session (sourcing .bashrc)..."
# --- Improvement: Added warning on failure ---
source "$BASHRC_FILE" || echo "[WARNING] Failed to source $BASHRC_FILE. You may need to restart Termux for the 'ydl' alias to work."
echo

# --- Final Instructions ---
echo "=============================="
echo " Setup Script Finished"
echo "=============================="
echo " IF NO ERRORS WERE REPORTED ABOVE:"
echo " -> Ensure you ran 'termux-setup-storage' and GRANTED permission."
echo " -> You can now try using the command: ydl <video_url>"
echo " -> Videos should save to: /storage/emulated/0/Download/"
echo " -> To update yt-dlp in the future, run: yt-dlp -U"
echo " -> -> -> If the 'ydl' command isn't found, please RESTART Termux."
echo "=============================="
echo
echo "--- All done. ---"

# --- Improvement: Explicitly exit with success code ---
exit 0