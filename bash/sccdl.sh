#!/data/data/com.termux/files/usr/bin/bash
# --------------------------------------------------
# SoundCloud Downloader (sccdl) — Termux Edition
# Author : Rishabh (Sonu)
# Usage  : sccdl <soundcloud_url>
# Notes  : Keeps behavior: bestaudio + embed thumbnail + metadata
# --------------------------------------------------

set -o pipefail

# --- helpers ---
err() { printf "[ERROR] %s\n" "$1" >&2; exit 1; }
info(){ printf "[INFO] %s\n" "$1"; }
ok()  { printf "[SUCCESS] %s\n" "$1"; }
warn(){ printf "[WARNING] %s\n" "$1"; }

# --- checks ---
command -v yt-dlp >/dev/null 2>&1 || err "yt-dlp not found. Install: pkg update && pkg install python ffmpeg && pip install -U yt-dlp"
command -v ffmpeg >/dev/null 2>&1 || err "ffmpeg not found. Install: pkg install ffmpeg"

# --- args ---
URL="$1"
[ -z "$URL" ] && { printf "[USAGE] sccdl <soundcloud_url>\n"; exit 1; }

# --- pick output directory ---
# Prefer shared storage/Download/SoundCloud if available (after termux-setup-storage), else use current dir
OUTDIR="$PWD"
if [ -d "$HOME/storage/shared/Download" ]; then
  OUTDIR="$HOME/storage/shared/Download/SoundCloud"
fi
mkdir -p "$OUTDIR" || err "Cannot create output directory: $OUTDIR"
cd "$OUTDIR" || err "Cannot enter: $OUTDIR"

# --- download ---
info "Downloading from: $URL"
yt-dlp -f bestaudio --embed-thumbnail --add-metadata "$URL"
rc=$?

if [ $rc -ne 0 ]; then
  err "Download failed. Check the URL or your connection."
fi

# --- find last downloaded regular file (newest) ---
LASTFILE="$(ls -1tp 2>/dev/null | grep -v '/$' | head -n 1)"

if [ -n "$LASTFILE" ]; then
  ok "Saved to: $(pwd)/$LASTFILE"
else
  warn "Download complete, but could not detect saved file."
fi

exit 0