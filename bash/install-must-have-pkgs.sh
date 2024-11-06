#!/bin/bash

# README: Install Essential Packages Script

# Overview
# This script installs a list of essential packages on a fresh Linux install. It works across multiple Linux distributions with minor adaptations.

# Instructions
#   Usage Across Distros
#         Debian-based (Ubuntu, Mint): Uses apt.
#         Arch-based (Manjaro, Arch): Uses pacman.
#         Fedora/RHEL-based: Uses dnf or yum.
#   Package Naming
#         Some package names may vary by distro (e.g., vlc is universal, but gnome-screenshot may differ).
#   Modify the Script
#         Replace sudo apt install with the appropriate command for your distro:
#             Arch: sudo pacman -S <package-name>
#             Fedora: sudo dnf install <package-name>

# Running the Script
#     Save the script as install-must-have-pkgs.sh
#     Make Executable: Run chmod +x install-must-have-pkgs.sh
#     Execute: Use ./install-must-have-pkgs.sh

# Update system
sudo apt update && sudo apt upgrade -y

# List of packages
packages=(
    curl
    wget
    git
    vim
    neofetch
    htop
    gnome-tweaks
    ffmpeg
    yt-dlp
    vlc
    zip
    unzip
    gnome-screenshot
    gparted
    zsh
    tmux
    ranger
    fd-find
    ripgrep
    tree
    python3-pip
    nodejs
    npm
    docker.io
    ncdu
    bat
    exiftool
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt install -y "$package"
done

# Post-install steps
echo "Installing Oh My Zsh for zsh customization..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Cleaning up unnecessary files..."
sudo apt autoremove -y && sudo apt clean

echo "All packages installed successfully!"
