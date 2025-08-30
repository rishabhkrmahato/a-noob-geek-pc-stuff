# 🎵 Audio Compressor

A simple Windows batch script to compress audio files using OPUS codec for optimal speech compression.

## ✨ Features

- **Batch Processing** - Converts all audio files in the current directory
- **High Compression** - Uses OPUS codec at 16kbps for speech-optimized compression
- **Multiple Formats** - Supports MP3, WAV, M4A, AAC, FLAC, OGG
- **Clean Output** - Organized compressed files in dedicated folder
- **Error Handling** - Clear success/failure indicators

## 📋 Requirements

- Windows OS
- [FFmpeg](https://ffmpeg.org/download.html) installed and added to PATH

## 🚀 Usage

1. Place the script in the folder containing your audio files
2. Double-click `compress_audio.bat` or run from command prompt
3. Compressed files will be saved in the `compressed` folder

```batch
# Example folder structure after running:
📁 your-audio-folder/
├── 📄 compress_audio.bat
├── 🎵 recording1.mp3
├── 🎵 recording2.wav
└── 📁 compressed/
    ├── 🎵 recording1.opus
    └── 🎵 recording2.opus
```

## ⚙️ Technical Details

- **Codec**: libopus
- **Bitrate**: 16kbps (optimized for speech)
- **Output Format**: .opus
- **Compression Ratio**: ~90% size reduction typical

## 🛠️ Customization

To modify compression settings, edit the ffmpeg parameters in the script:

```batch
# Current setting (speech-optimized)
ffmpeg -i "input.mp3" -c:a libopus -b:a 16k "output.opus"

# Higher quality (32kbps)
ffmpeg -i "input.mp3" -c:a libopus -b:a 32k "output.opus"
```

## 📝 Notes

- Original files are preserved (not deleted)
- OPUS format provides excellent compression for speech recordings
- Ideal for call recordings, voice notes, and podcasts
- May not be suitable for high-fidelity music

---

*Part of [a-noob-geek-pc-stuff](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff) collection*