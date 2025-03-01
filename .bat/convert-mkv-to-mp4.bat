:: ================================================================================================
:: Description:
::MKV to MP4 Converter (Using FFmpeg)
::
:: This batch script converts an MKV file to MP4 using FFmpeg 
:: while keeping the original codecs intact (`-c copy`).
::
:: Key Features:
:: - Checks if FFmpeg is installed before proceeding.
:: - Prompts the user to enter the MKV file path.
:: - Converts the MKV file to MP4 without re-encoding.
:: - Automatically generates an output filename based on the input.
::
:: Hard-Coded Details:
:: - `ffmpeg` is expected to be installed and accessible in the system PATH.
:: - The output file retains the same name but with an `.mp4` extension.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify the FFmpeg installation check if using a different package manager.
:: 2. Change the output format if a different container is needed.
:: 3. Adjust FFmpeg parameters to enable re-encoding if required.
::
:: Usage:
:: - Run the script and enter the full path of the MKV file when prompted.
:: - FFmpeg will convert the file while preserving audio and video codecs.
::
:: Dependencies:
:: - FFmpeg (install via Chocolatey: `choco install ffmpeg`).
::
:: Output:
:: - The converted MP4 file is saved in the same directory as the input.
::
:: Error Handling:
:: - If FFmpeg is missing, the script suggests installation via Chocolatey.
:: - If the conversion fails, FFmpeg will output an error message.
::
:: Notes:
:: - This script uses `-c copy` to avoid re-encoding, ensuring a fast conversion.
:: - If the MKV file contains incompatible codecs, consider using a different FFmpeg command.
:: ================================================================================================


@echo off
:: Check if FFmpeg is installed
ffmpeg -version >nul 2>&1 || (
    echo FFmpeg not found! Install it via:
    echo choco install ffmpeg ^&^& exit /b
    pause
    exit /b
)

:: Get input file
set /p inputPath="Enter MKV file path: "
set "outputPath=%inputPath:.mkv=.mp4%"

:: Convert MKV to MP4
ffmpeg -i "%inputPath%" -c copy "%outputPath%"

echo Conversion complete: %outputPath%
pause
