#!/bin/bash

# Title: yt-dlp+termux-downloader-andorid

# Description: Script to install and configure yt-dlp on Termux for Android

# Requirements:
# 1. **F-Droid**: Download and install F-Droid to get Termux, if not installed.
# 2. **Permissions**: Grant all permissions to Termux, especially **Storage Access**.
#      ---This is essential for downloads to save to your device's storage.

# 3. **Usage**:
#    - This script installs yt-dlp and sets up a convenient command to download videos
#      using `yt-dlp` with best video and audio settings.
#    - Requires an active internet connection.
#    - After setup, simply use: `ydl <video_url>` to download any video.
#    - Output will be saved to the default download location for Termux, 
#      defualt for termux is `/data/data/com.termux/files/home/storage/downloads`.

# 4. for **Updating**:
#    - Update `yt-dlp` anytime using: `yt-dlp -U`
#    - Check help commands with `yt-dlp -h`
# 5. **Update Packages**: If using Termux after a long time, run `pkg update && pkg upgrade -y`

# RUN THIS SCRIPT USING " bash yt-dlp+termux-downloader-android.sh " command in termux.

echo "Starting setup for yt-dlp in Termux..."

# Update & Upgrade
echo "Updating and upgrading Termux packages..."
pkg update -y && pkg upgrade -y

# Install Python
echo "Installing Python..."
pkg install python -y

# Install yt-dlp
echo "Installing yt-dlp..."
pip install yt-dlp

# Install FFmpeg
echo "Installing FFmpeg..."
pkg install ffmpeg -y

# ---Add yt-dlp alias to .bashrc for easy use
echo "Setting up yt-dlp alias in .bashrc..."
{
    echo ""
    echo "# Alias to download videos with yt-dlp using best video and audio quality"
    echo "alias ydl=\"yt-dlp -f 'bestvideo+bestaudio' -o '/storage/emulated/0/Download/%(title)s.%(ext)s'\""
} >> ~/.bashrc

# Reload .bashrc to apply the alias
echo "Reloading .bashrc..."
source ~/.bashrc

echo ""
echo "=============================="
echo " Setup Complete!"
echo "=============================="
echo "Instructions:"
echo " - To download a video, use: ydl <video_url>"
echo " - Videos will be saved to: ~/storage/downloads/"
echo " - For updating yt-dlp: yt-dlp -U"
echo " - To view yt-dlp help: yt-dlp -h"
echo "=============================="

echo "All done! Enjoy downloading videos with yt-dlp on Termux."
