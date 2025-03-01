import os
import sys
import subprocess

# Check if FFmpeg is installed
def check_ffmpeg():
    try:
        subprocess.run(["ffmpeg", "-version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
    except subprocess.CalledProcessError:
        print("Error: FFmpeg is not installed or not in PATH.")
        sys.exit(1)
    except FileNotFoundError:
        print("Error: FFmpeg executable not found. Install it first.")
        sys.exit(1)

# Get valid input file path
def get_valid_file():
    while True:
        input_file = input("Enter video file path: ").strip().strip('"')
        if os.path.exists(input_file):
            return input_file
        print("Error: File not found. Please enter a valid path.")

# Get valid segment time in minutes
def get_valid_time():
    while True:
        try:
            minutes = int(input("Enter segment duration in minutes (e.g., 22): ").strip())
            if minutes > 0:
                return minutes * 60  # Convert to seconds
        except ValueError:
            pass
        print("Error: Invalid input. Please enter a positive integer.")

# Main function
def split_video():
    check_ffmpeg()
    
    input_file = get_valid_file()
    segment_time = get_valid_time()
    
    input_folder = os.path.dirname(input_file)
    base_name, ext = os.path.splitext(os.path.basename(input_file))
    
    output_pattern = os.path.join(input_folder, f"{base_name}_part%03d{ext}")

    # Run FFmpeg command
    command = [
        "ffmpeg", "-i", input_file, "-c", "copy", "-map", "0",
        "-segment_time", str(segment_time), "-f", "segment",
        "-reset_timestamps", "1", "-start_number", "1", output_pattern
    ]

    print("\nSplitting video...")
    subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    print(f"\n✅ Job completed! Output files are in: {input_folder}")

if __name__ == "__main__":
    split_video()
