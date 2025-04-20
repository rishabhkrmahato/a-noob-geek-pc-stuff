#!/data/data/com.termux/files/usr/bin/bash

# Enhanced Termux Setup Script
# Installs a curated list of essential packages.
# Ensures the system is up-to-date first.

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Pipe commands should return the exit status of the last command that failed,
# or zero if no command failed.
set -o pipefail

echo "--- Starting Enhanced Termux Setup ---"

# 1. Update package lists and upgrade existing packages
# ------------------------------------------------------
echo "[INFO] Updating package lists..."
pkg update -y || { echo "[ERROR] Failed to update package lists."; exit 1; }

echo "[INFO] Upgrading installed packages..."
pkg upgrade -y || { echo "[ERROR] Failed to upgrade packages."; exit 1; }

# 2. Define the list of essential packages
# -----------------------------------------
# Added coreutils, gnupg, tar, less, man. Removed nodejs, ranger, ffmpeg, neofetch.
# Kept nano as the primary easy editor. Vim can be installed manually if preferred.
essential_packages=(
    coreutils  # Basic file, shell and text manipulation utilities
    curl       # Tool for transferring data with URLs
    wget       # Simple network downloader
    git        # Version control system
    openssh    # Secure Shell client and server tools
    gnupg      # For package signature verification and encryption
    nano       # Easy-to-use text editor
    htop       # Interactive process viewer
    tmux       # Terminal multiplexer (manage multiple sessions)
    python     # Python 3 programming language
    python-pip # Package installer for Python
    zip        # Utility for ZIP archives
    unzip      # Utility for ZIP archives
    tar        # Utility for TAR archives
    less       # Pager for viewing text files
    man        # Manual page reader
    which      # Locate a command executable
    jq         # Command-line JSON processor
    ncdu       # NCurses Disk Usage analyzer
    ffmpeg     # Multimedia framework (for audio/video processing)
)

echo "[INFO] Installing/Updating essential packages..."

# 3. Install packages from the list
# ----------------------------------
# 'pkg install' will install if not present, or update if an older version exists.
pkg install -y "${essential_packages[@]}" || { echo "[ERROR] Failed to install one or more essential packages."; exit 1; }

# 4. Optional: Install yt-dlp separately via pip (if desired)
# -----------------------------------------------------------
echo "[INFO] Installing yt-dlp using pip..."
pip install --upgrade yt-dlp || { echo "[WARNING] Failed to install yt-dlp via pip. Is python-pip installed correctly?"; }

# 5. Optional: Clean up downloaded package files (saves space)
# -----------------------------------------------------------
echo "[INFO] Cleaning up package cache..."
pkg clean

# 6. Final Confirmation
# ---------------------
echo "" # Newline for spacing
echo "----------------------------------------"
echo "[SUCCESS] Essential Termux setup complete!"
echo "----------------------------------------"
echo "Installed/Updated packages:"
for pkg_name in "${essential_packages[@]}"; do
  echo "  - $pkg_name"
done
echo "----------------------------------------"
echo "You can install other packages using 'pkg install <package_name>'."
echo "Example: pkg install vim nodejs neofetch"
echo "----------------------------------------"

exit 0