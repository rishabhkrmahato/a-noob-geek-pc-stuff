
#!/usr/bin/env bash

# Universal Auto Video Splitter
# Requires Bash and FFmpeg.
# Output files are saved beside this script.

set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d_%H%M%S)_$$"

say() { printf '%s\n' "$*"; }
fail() { say "ERROR: $*" >&2; exit 1; }

install_ffmpeg() {
    say "FFmpeg/ffprobe is missing."
    read -r -p "Try installing FFmpeg now? [y/N] " answer

    case "$answer" in
        y|Y|yes|YES) ;;
        *) fail "Install FFmpeg and rerun this script." ;;
    esac

    if command -v pkg >/dev/null 2>&1; then
        pkg install ffmpeg || fail "Installation failed."
    elif command -v brew >/dev/null 2>&1; then
        brew install ffmpeg || fail "Installation failed."
    elif command -v apt-get >/dev/null 2>&1; then
        if [[ "$(id -u)" -eq 0 ]]; then
            apt-get update && apt-get install -y ffmpeg ||
                fail "Installation failed."
        elif command -v sudo >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get install -y ffmpeg ||
                fail "Installation failed."
        else
            fail "Install FFmpeg using your system package manager."
        fi
    elif command -v dnf >/dev/null 2>&1; then
        if [[ "$(id -u)" -eq 0 ]]; then
            dnf install -y ffmpeg || fail "Installation failed."
        elif command -v sudo >/dev/null 2>&1; then
            sudo dnf install -y ffmpeg || fail "Installation failed."
        else
            fail "Install FFmpeg using your system package manager."
        fi
    elif command -v pacman >/dev/null 2>&1; then
        if [[ "$(id -u)" -eq 0 ]]; then
            pacman -S --needed ffmpeg || fail "Installation failed."
        elif command -v sudo >/dev/null 2>&1; then
            sudo pacman -S --needed ffmpeg || fail "Installation failed."
        else
            fail "Install FFmpeg using your system package manager."
        fi
    else
        fail "Unsupported package manager. Install FFmpeg manually."
    fi

    command -v ffmpeg >/dev/null 2>&1 &&
    command -v ffprobe >/dev/null 2>&1 ||
        fail "FFmpeg or ffprobe is still unavailable."
}

if ! command -v ffmpeg >/dev/null 2>&1 ||
   ! command -v ffprobe >/dev/null 2>&1; then
    install_ffmpeg
fi

say "======================================"
say "       AUTO VIDEO SPLITTER"
say "======================================"
say "Output folder: $SCRIPT_DIR"
say ""

# Accept a path as an argument or prompt for it.
INPUT="${1:-}"
if [[ -z "$INPUT" ]]; then
    read -r -p "Video path: " INPUT
fi

INPUT="${INPUT/#\~/$HOME}"

if [[ "$INPUT" != /* ]]; then
    INPUT="$PWD/$INPUT"
fi

[[ -f "$INPUT" ]] || fail "Video file not found: $INPUT"

DURATION="$(ffprobe -v error \
    -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$INPUT")" ||
    fail "Could not read video duration."

[[ "$DURATION" =~ ^[0-9]+([.][0-9]+)?$ ]] ||
    fail "Invalid video duration."

VIDEO_STREAM="$(ffprobe -v error -select_streams v:0 \
    -show_entries stream=codec_type -of csv=p=0 "$INPUT")"

[[ "$VIDEO_STREAM" == "video" ]] ||
    fail "No usable video stream found."

say ""
awk -v d="$DURATION" 'BEGIN {
    printf "Detected duration: %02d:%02d:%05.2f\n",
    int(d/3600), int(d/60)%60, d-int(d/60)*60
}'

say ""
say "Choose cutting mode:"
say "1) Fast     - no re-encoding; keyframe-limited cuts"
say "2) Precise  - re-encode; more accurate cut boundaries"

read -r -p "Mode [1/2]: " MODE
[[ "$MODE" == "1" || "$MODE" == "2" ]] ||
    fail "Choose 1 or 2."

read -r -p "Number of equal parts (2-1000): " PARTS
[[ "$PARTS" =~ ^[0-9]+$ ]] &&
    (( PARTS >= 2 && PARTS <= 1000 )) ||
    fail "Enter a whole number from 2 to 1000."

read -r -p "Maximum duration per part (seconds): " MAX
[[ "$MAX" =~ ^[0-9]+$ ]] && (( MAX >= 1 )) ||
    fail "Enter a positive whole number of seconds."

TARGET="$(awk -v d="$DURATION" -v n="$PARTS" \
    'BEGIN { printf "%.9f", d/n }')"

if ! awk -v t="$TARGET" -v m="$MAX" \
    'BEGIN { exit !(t <= m) }'; then
    NEEDED="$(awk -v d="$DURATION" -v m="$MAX" \
        'BEGIN { printf "%d", int(d/m)+1 }')"
    fail "Equal parts exceed the limit. Try at least $NEEDED parts."
fi

# Generate exact target timestamps for all internal boundaries.
CUT_TIMES="$(awk -v d="$DURATION" -v n="$PARTS" \
    'BEGIN {
        for (i=1; i<n; i++) {
            if (i>1) printf ","
            printf "%.6f", d*i/n
        }
    }')"

BASE="$(basename -- "$INPUT")"
BASE="${BASE%.*}"
SAFE_BASE="$(printf '%s' "$BASE" |
    tr -cs '[:alnum:]_.-' '_')"

if [[ "$MODE" == "1" ]]; then
    EXT="mkv"
    PREFIX="$SCRIPT_DIR/${SAFE_BASE}_fast_${STAMP}_part_"
    say ""
    say "Fast mode: copying streams without re-encoding."
    say "Cuts may move to nearby keyframes."
else
    EXT="mp4"
    PREFIX="$SCRIPT_DIR/${SAFE_BASE}_precise_${STAMP}_part_"
    say ""
    say "Precise mode: high-quality H.264/AAC re-encoding."
    say "This takes longer and is not mathematically lossless."
fi

say "Target duration: $TARGET seconds"
say "Maximum duration: $MAX seconds"
say ""

if [[ "$MODE" == "1" ]]; then
    ffmpeg -hide_banner -nostdin -i "$INPUT" \
        -map 0:v:0 -map '0:a?' \
        -c copy \
        -f segment \
        -segment_format matroska \
        -segment_times "$CUT_TIMES" \
        -reset_timestamps 1 \
        -segment_start_number 1 \
        "${PREFIX}%03d.$EXT" ||
        fail "FFmpeg failed. Check the input and available storage."
else
    ffmpeg -hide_banner -nostdin -i "$INPUT" \
        -map 0:v:0 -map '0:a?' \
        -sn -dn \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        -sc_threshold 0 \
        -force_key_frames "$CUT_TIMES" \
        -f segment \
        -segment_format mp4 \
        -segment_times "$CUT_TIMES" \
        -segment_time_delta 0.05 \
        -reset_timestamps 1 \
        -segment_start_number 1 \
        "${PREFIX}%03d.$EXT" ||
        fail "FFmpeg failed. Check the input and available storage."
fi

say ""
say "======================================"
say "        OUTPUT VERIFICATION"
say "======================================"

COUNT=0
OVER=0

for FILE in "${PREFIX}"*."$EXT"; do
    [[ -f "$FILE" ]] || continue
    COUNT=$((COUNT + 1))

    SEC="$(ffprobe -v error \
        -show_entries format=duration \
        -of default=noprint_wrappers=1:nokey=1 "$FILE")" ||
        fail "Could not verify $(basename "$FILE")."

    printf '%s | %s seconds' "$(basename "$FILE")" "$SEC"

    if awk -v d="$SEC" -v m="$MAX" \
        'BEGIN { exit !(d > m + 0.02) }'; then
        say " | WARNING: OVER LIMIT"
        OVER=$((OVER + 1))
    else
        say " | OK"
    fi
done

say ""
say "Expected parts: $PARTS"
say "Created parts:  $COUNT"

if (( COUNT != PARTS )); then
    say "WARNING: The number of files differs from the request."
fi

if (( OVER > 0 )); then
    say "WARNING: $OVER part(s) exceed the duration limit."
elif (( COUNT == PARTS )); then
    say "All parts passed the duration check."
fi

say "Original video was not modified."
say "Output folder: $SCRIPT_DIR"
say "Finished."

