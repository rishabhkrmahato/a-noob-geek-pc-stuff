#!/data/data/com.termux/files/usr/bin/bash

# Update and upgrade existing packages
pkg update && pkg upgrade -y

# Essential packages list
packages=(
    curl       # Web requests and downloading
    git        # Version control
    htop       # System monitoring tool
    vim        # Text editor
    nano       # Another lightweight text editor
    python     # Python programming language
    python-pip # Python package manager
    nodejs     # JavaScript runtime
    tmux       # Terminal multiplexer
    ranger     # Console file manager
    ffmpeg     # Multimedia processor
    neofetch   # System information display
    openssh    # SSH client
    zip        # Zip compression
    unzip      # Unzip compression
    wget       # File downloader
    ncdu       # Disk usage analyzer
    jq         # JSON processor
    which      # Find the location of executables
)

# Install each package
for package in "${packages[@]}"; do
    pkg install -y "$package"
done

# Install yt-dlp using pip
pip install yt-dlp

echo "All essential packages, have been successfully installed on Termux!"
