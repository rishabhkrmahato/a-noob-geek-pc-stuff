# 📞 Compress Call Recordings

A simple Windows batch script to **compress call recordings** (or any audio files) into the modern **Opus format** with very small size while keeping speech clear and usable.

---

## ✨ Features
- Converts all supported audio files in the current folder:
  - `.wav`, `.m4a`, `.mp3`, `.aac`, `.amr`, `.ogg`, `.flac`

- Uses **Opus codec at 12 kbps mono** (optimized for voice).

- Creates a `compressed/` folder → originals stay untouched.

- Clean console output with success/error reporting.

- Lightweight, dependency-free (only requires `ffmpeg`).

---

## 📦 Requirements
- [ffmpeg](https://ffmpeg.org/) must be installed and in PATH.  

  If you use [Scoop](https://scoop.sh/):
  ```powershell
  scoop install ffmpeg

---

## 🚀 Usage

- Place compress-call-recordings.bat inside your recordings folder.

- Double-click the script.

- Compressed .opus files will be saved inside a new compressed/ folder.

---

## 📉 Compression Ratio

- Original: 1.7 GB of recordings

- Compressed: ~160 MB (90%+ smaller)

- Quality: Clear enough for future use (speech-only optimization).

---

## ⚠️ Notes

- This script is optimized for speech recordings (calls, lectures, notes).

- Not recommended for music → quality will drop significantly.

- If you want slightly better clarity, adjust the bitrate in the script:
  b:a 16k

---

📜 License

- This script is released under the MIT License – free to use, modify, and share.