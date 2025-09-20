# 🎵 Audio Compressor

A simple, safe batch audio compression tool that converts audio files to efficient Opus format.

## ✨ Features

- **Safe Processing** - Never overwrites original files
- **Batch Compression** - Processes multiple files automatically  
- **Multiple Formats** - Supports M4A, MP3, WAV, AAC, FLAC, OGG, AMR
- **Detailed Logging** - Tracks all operations with timestamps
- **Space Efficient** - Converts to Opus format at 16kbps

## 🚀 Quick Start

### Prerequisites

- `ffmpeg` installed and accessible in PATH
- Bash shell environment

### Basic Usage

1. **Place the script** in a folder containing your audio files
2. **Make executable**: `chmod +x compress-call-recordings.sh`
3. **Run**: `./compress-call-recordings.sh`

The script will:
- Create a `compressed/` folder for output files
- Generate a `ccr_log.txt` with processing details
- Convert all supported audio files to Opus format

## 📱 Termux Usage (Android)

### Setup
```bash
# Install required packages
pkg update && pkg upgrade
pkg install ffmpeg

# Download the script
curl -O https://raw.githubusercontent.com/rishabhkrmahato/a-noob-geek-pc-stuff/main/compress-call-recordings.sh
chmod +x compress-call-recordings.sh
```

### Running on Android
```bash
# Navigate to your audio files directory
cd /sdcard/Recordings  # or wherever your audio files are

# Copy and run the script
cp ~/compress-call-recordings.sh .
./compress-call-recordings.sh
```

> **Note**: On Android, you may need to grant Termux storage permissions: `termux-setup-storage`

## 📁 File Structure

```
your-audio-folder/
├── compress-call-recordings.sh
├── audio1.m4a
├── audio2.mp3
├── compressed/           # Created automatically
│   ├── audio1.opus
│   └── audio2.opus
└── ccr_log.txt          # Processing log
```

## 🔧 Customization

### Change Output Format
Modify the `ffmpeg` command line (around line 25):
```bash
ffmpeg ... -c:a libopus -b:a 32k "$out"  # Higher quality
ffmpeg ... -c:a libmp3lame -b:a 128k "${out%.opus}.mp3"  # MP3 output
```

### Add More Formats
Edit the `exts` variable:
```bash
exts="m4a mp3 wav aac flac ogg amr wma"  # Added WMA support
```

## 📝 Output

- **Compressed files**: `./compressed/` directory
- **Processing log**: `./ccr_log.txt`
- **Console output**: Real-time progress updates

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| `ffmpeg: command not found` | Install ffmpeg: `pkg install ffmpeg` (Termux) or download from [ffmpeg.org](https://ffmpeg.org) |
| Permission denied | Run `chmod +x compress-call-recordings.sh` |
| No files processed | Check if audio files have supported extensions |

## 📊 Why Opus?

- **Excellent quality** at low bitrates
- **Open standard** - no licensing issues
- **Wide support** - Works on most modern devices
- **Space efficient** - Significant file size reduction

---

*Part of the [a-noob-geek-pc-stuff](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff) collection*