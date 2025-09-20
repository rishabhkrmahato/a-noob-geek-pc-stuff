#!/usr/bin/env bash
# ccr_safe.sh - safer Termux batch audio compressor
set -euo pipefail
IFS=$'\n\t'

OUTDIR="$PWD/compressed"
LOG="$PWD/ccr_log.txt"
mkdir -p "$OUTDIR"
: > "$LOG"

echo "Compressing audio files in: $PWD"
echo "Output -> $OUTDIR"
echo "Log -> $LOG"
echo

# file extensions we accept (lowercase). Adjust if needed.
exts="m4a mp3 wav aac flac ogg amr"

shopt -s nullglob
# Use plain for loop over glob — simplest, robust to spaces and unicode in filenames.
for file in *; do
  # only regular files
  [[ -f "$file" ]] || continue

  # get lowercase extension
  lc="${file##*.}"
  lc="${lc,,}"

  if ! echo "$exts" | grep -qw "$lc"; then
    continue
  fi

  echo "Processing: $file"
  out="$OUTDIR/${file%.*}.opus"

  # run ffmpeg, capture stderr to per-file log line
  if ffmpeg -hide_banner -loglevel error -y -i "$file" -c:a libopus -b:a 16k "$out" 2>>"$LOG"; then
    echo "[OK] $out"
    printf "[OK] %s -> %s\n" "$file" "$out" >> "$LOG"
  else
    echo "[ERR] Failed: $file (see $LOG)"
    printf "[ERR] %s\n" "$file" >> "$LOG"
  fi
done

echo
echo "Done. Check $LOG for detailed errors."