# Media Link Launcher

A modern GUI application for launching multiple media links in your preferred video player with automatic spacing between launches.

![Python](https://img.shields.io/badge/python-3.7+-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

- 🎨 **Modern UI** - Built with CustomTkinter for a sleek, contemporary interface
- 🎬 **Multi-Player Support** - Compatible with VLC, MPC-HC, and mpv
- 📋 **Quick Paste** - One-click clipboard paste functionality
- ⏱️ **Auto-Spacing** - 5-second delay between launches to prevent system overload
- 🔄 **Multiple Instances** - Opens each link in a separate player instance (MPC-HC `/new` flag support)
- 🌓 **Theme Support** - Automatically adapts to system dark/light mode

## Screenshots

![Media Launcher Interface](screenshot.png)

## Requirements

### Python Dependencies
```bash
pip install customtkinter
```

### Media Players (at least one required)
- **VLC Media Player** - [Download](https://www.videolan.org/vlc/)
- **MPC-HC** (via K-Lite Codec Pack) - [Download](https://codecguide.com/download_kl.htm)
- **mpv** - [Download](https://mpv.io/installation/)

## Installation

1. Clone this repository or download `media-link-launcher.py`

2. Install required Python package:
```bash
pip install customtkinter
```

3. Configure player paths in the script if needed (auto-detection works for most installations):
```python
MPC_PATH = r"C:\Program Files (x86)\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe"
VLC_PATH = shutil.which("vlc") or r"C:\Program Files\VideoLAN\VLC\vlc.exe"
MPV_PATH = shutil.which("mpv") or "mpv.exe"
```

## Usage

1. Run the application:
```bash
python media-link-launcher.py
```

2. **Add Links:**
   - Paste your media links directly into the text box, or
   - Click "Paste from Clipboard" to auto-paste

3. **Select Player:**
   - Choose VLC, MPC-HC, or mpv via radio buttons

4. **Launch:**
   - Click "LAUNCH MEDIA" to open all links sequentially
   - Each link opens in a new player instance with a 5-second delay between launches

## Supported Link Types

- Direct video URLs (MP4, MKV, AVI, etc.)
- Streaming links (YouTube, Twitch, etc.)
- Local file paths
- Network shares (SMB/UNC paths)
- M3U8 playlists
- Any media format supported by your chosen player

## Configuration

### Changing Default Player
Edit line 43 in the script:
```python
self.player_var = ctk.StringVar(value="VLC")  # Change to "MPC-HC" or "mpv"
```

### Adjusting Launch Delay
Modify line 94 to change the 5-second delay:
```python
time.sleep(5)  # Change to desired seconds
```

### Custom Theme
Edit lines 9-10:
```python
ctk.set_appearance_mode("Dark")  # Options: "System", "Dark", "Light"
ctk.set_default_color_theme("green")  # Options: "blue", "green", "dark-blue"
```

## Troubleshooting

### Player Not Found Error
- Verify player installation paths match the script configuration
- Use full absolute paths for custom installations
- Ensure player executables are in system PATH

### Links Not Opening
- Check if links are valid and accessible
- Test links manually in your browser/player first
- Verify network connectivity for streaming links

### Permission Errors
- Run as administrator if accessing protected directories
- Check antivirus isn't blocking subprocess launches

## Example Use Cases

- **Batch Streaming** - Open multiple Twitch/YouTube streams simultaneously
- **Video Comparison** - Compare different video sources side-by-side
- **Playlist Launching** - Queue up multiple local videos across instances
- **Multi-Monitor Setup** - Launch videos on different displays

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests to the [GitHub repository](https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff).

## License

This project is open-source and available under the MIT License.

## Changelog

### v1.0.0 (Current)
- Initial release
- Multi-player support (VLC, MPC-HC, mpv)
- CustomTkinter modern UI
- Clipboard paste functionality
- Auto-spacing between launches
- MPC-HC new instance flag support

## Credits

Built with [CustomTkinter](https://github.com/TomSchimansky/CustomTkinter)

---

**Note:** This tool is designed for personal use. Respect copyright and terms of service when accessing media content.