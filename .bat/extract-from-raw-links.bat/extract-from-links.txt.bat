:: ================================================================================================
:: Description:
::
:: Batch File Download and Merge
::
:: This batch script reads a list of URLs from a `links.txt` file, downloads 
:: their contents using `curl`, and saves them as separate `.txt` files. 
:: After downloading, it merges all downloaded files into a single `combined.txt`.
::
:: Key Features:
:: - Creates an output folder (`extracted`) if it doesn’t exist.
:: - Reads URLs from `links.txt` and downloads each file.
:: - Saves downloaded content with the file's name extracted from the URL.
:: - Merges all downloaded `.txt` files into `combined.txt`.
::
:: Usage:
:: - Create a `links.txt` file with one URL per line.
:: - Run the script to download and merge the files.
::
:: Hard-Coded Details:
:: - `output_folder=extracted`: Folder where downloaded files are stored.
:: - `links.txt`: The file containing the list of URLs.
:: - `combined.txt`: The final merged file.
::
:: Steps to Update Hard-Coded Details:
:: 1. Change `output_folder` to a different directory if needed.
:: 2. Modify `"links.txt"` if using a different input file name.
:: 3. Adjust `"combined.txt"` if a different merged filename is preferred.
::
:: Dependencies:
:: - `curl` (included by default in modern Windows versions).
::
:: Output:
:: - Individual downloaded files in the `extracted` folder.
:: - A `combined.txt` file containing all merged content.
::
:: Error Handling:
:: - If `links.txt` does not exist, the script will fail.
:: - If a download fails, it won’t interrupt the rest of the script.
::
:: Notes:
:: - Ensure `links.txt` contains valid URLs.
:: - Consider adding error checking to verify successful downloads.
:: ================================================================================================


@echo off
set output_folder=extracted
if not exist %output_folder% mkdir %output_folder%

for /f "usebackq tokens=*" %%L in ("links.txt") do (
    echo Downloading: %%L
    curl -s %%L -o %output_folder%\%%~nL.txt
)
echo All files downloaded to the "%output_folder%" folder.
copy /b extracted\*.txt combined.txt
pause
