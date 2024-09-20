r"""
============================ INSTALLATION GUIDE ============================

1. **Install Python:**
   - Download the latest version of Python from https://www.python.org/downloads/
   - Follow the installation instructions.

2. **Add Python to PATH:**
   - During the Python installation, make sure to check the box that says "Add Python to PATH."

3. **Install pip:**
   - Pip is included with Python installations. Verify pip is installed by running `pip --version` in your terminal.
   - If pip is not installed, you can get it by running `python -m ensurepip --upgrade` in the terminal.

4. **Install YT-DLP**
   - Open your terminal and run: 
        pip install yt-dlp

5. **Run the Python Script:**
   - Save this script.
   - Open your terminal, navigate (cd ) to the folder where it is saved, and run: `python ytdlp-downloader.py`

=============================================================================

**IMPORTANT:**
- Change the download folder location in the `download_video` function:
  - Current location: 'C:\Users\mahat\Videos\%(id)s__%(format_id)s__%(upload_date)s.%(ext)s'
  - Update it to your preferred folder path.
    [shift+right-click > copy-as-path]
    [change this portion only: C:\Users\mahat\Videos\]
    
=============================================================================

Download this file > rigth-click > new > create shortcut > python "(copy-as-path this file)"
double-click-run&enjoy
tip: move of the shortcut to "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\" [name it anything] & directly call from windows search

"""
import sys
import yt_dlp
import re

# Function to get the best video and audio formats based on TBR
def get_best_formats(url):
    ydl_opts = {
        'format': 'bestaudio/bestvideo',
        'quiet': True,
        'noplaylist': True
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=False)
        formats = info['formats']
        best_video = max((f for f in formats if f.get('vcodec') != 'none'), key=lambda f: f.get('tbr', 0))
        best_audio = max((f for f in formats if f.get('acodec') != 'none'), key=lambda f: f.get('tbr', 0))
        return best_video['format_id'], best_audio['format_id']

# Function to download video with best formats based on TBR
def download_video(url):
    video_format, audio_format = get_best_formats(url)
    ydl_opts = {
        'format': f'{video_format}+{audio_format}',
        'outtmpl': 'C:\\Users\\mahat\\Videos\\%(id)s__%(format_id)s__%(upload_date)s.%(ext)s'  # Change this path to your preferred download folder
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])

# Function to validate the URL and clean it
def validate_url(input_url):
    cleaned_url = input_url.strip().replace("'", "").replace('"', "")
    url_pattern = re.compile(r'^(https?://)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(/[^\s]*)?$')
    if url_pattern.match(cleaned_url):
        if not cleaned_url.startswith('http'):
            cleaned_url = 'https://' + cleaned_url
        return cleaned_url
    else:
        return None

# Main program loop for terminal-based downloading
def main():
    while True:
        # Ask for the video URL
        input_url = input("Enter the video URL (or type 'exit' to quit): ").strip()
        
        if input_url.lower() == 'exit':
            print("Exiting the program. Goodbye!")
            break
        
        validated_url = validate_url(input_url)
        
        if validated_url:
            print("Downloading...")
            download_video(validated_url)
            print("Download completed!")
        else:
            print("Invalid URL! Please enter a valid video URL.")

if __name__ == '__main__':
    main()
