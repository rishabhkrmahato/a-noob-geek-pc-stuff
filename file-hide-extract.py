# =================================
# FILE HIDING & EXTRACTION SCRIPT
# =================================

# Instructions and Examples:

# 1. Hide a FILE:
#    - This option allows you to combine a data file into a main file.
#    - You will be prompted to provide paths (SHIFT RIGHT CLICK ANYTHING & "copy as path") for:
#      - Main file (e.g., an image or any other file)
#      - Data file (e.g., a video or any other file you want to hide)
#      - Output file (where the combined file will be saved, MUST FOLLOW name.extension format)
   
#    - Example: Combining a.png and a.mp4 and saving as b.png.
#    Main Menu:
#    1. Hide a FILE
#    2. Extract the FILE
#    3. Exit
#    Enter your choice (1/2/3): 1
#    Enter the path to the main file: "C:\Users\mahat\Desktop\hide files in image\a.png"
#    Enter the path to the data file: "C:\Users\mahat\Desktop\hide files in image\a.mp4"
#    Enter the path to save the combined file: "C:\Users\mahat\Desktop\hide files in image\b.png" (*Specify the name and extension*)
#    File hidden successfully. Output saved to 'C:\Users\mahat\Desktop\hide files in image\b.png'.

# 2. Extract the FILE:
#    - This option extracts the hidden data from the combined file.
#    - You will need to provide the path of the combined file.
#    - The extracted file will be saved in the same directory as the script with the name "extracted-file".
   
#    - Example: Extracting hidden data from b.png and saving as extracted-file.
#    Main Menu:
#    1. Hide a FILE
#    2. Extract the FILE
#    3. Exit
#    Enter your choice (1/2/3): 2
#    Enter the path to the combined file: "C:\Users\mahat\Desktop\hide files in image\b.png"
#    File extracted successfully. (The file will be saved in the directory where the script is running from)
#    Output saved to 'c:\Users\mahat\Desktop\extracted-file'. (*Specify the type of file to the recipient*)
#    * The file is saved without an extension; use the appropriate program to open it. For example, use 7-Zip for .tar files or VLC for videos.

# 3. Exit:
#    - Quit the program.

# My Notes:
# - YOU NEED TO send the output file (e.g., an image file with a video hidden inside),+ the .len FILE (used to track the end of the image file binary),+ the .py SCRIPT (to extract the hidden file).
# - The main file will still open normally as it is; if it's an image, it will still open with any image viewer, though the file size will increase.
# - Fun project idea: Hide confidential content (e.g., a tarball) behind an image and keep the .len and .py script to yourself. Ensure the output file is sent as a document to avoid compression or re-encoding by social media sites.

# Notes and Precautions:
# - File Length: Ensure the .len file is always present with the combined file for successful extraction.
# - Path Handling: Provide full file paths and ensure they are correctly formatted.
# - File Names: The script saves the extracted file with a generic name ("extracted-file"). Make sure the recipient knows how to handle the extracted file.

# Potential Improvements:
# - Error Handling: Add more detailed error messages for file operations.
# - File Extension: Consider allowing the user to specify an extension for the extracted file.
# - Validation: Add checks for valid file paths and names.

import os

def clean_path(path):
    """Remove surrounding quotes from the path if present."""
    if path.startswith('"') and path.endswith('"'):
        return path[1:-1]
    if path.startswith("'") and path.endswith("'"):
        return path[1:-1]
    return path

def hide_file(main_file, data_file, output_file):
    """Hide a file by appending its data to the end of another file."""
    main_file = clean_path(main_file)
    data_file = clean_path(data_file)
    output_file = clean_path(output_file)

    # Check if the main file and data file exist
    if not os.path.exists(main_file):
        raise FileNotFoundError(f"Main file '{main_file}' not found.")
    if not os.path.exists(data_file):
        raise FileNotFoundError(f"Data file '{data_file}' not found.")
    
    # Check if the output path is a directory
    if os.path.isdir(output_file):
        raise PermissionError(f"Output path '{output_file}' is a directory. Please specify a file path.")
    
    # Read the main file and data file
    with open(main_file, 'rb') as f:
        main_data = f.read()
    
    with open(data_file, 'rb') as f:
        data = f.read()
    
    # Write the combined data to the output file
    with open(output_file, 'wb') as f:
        f.write(main_data)
        f.write(data)
    
    # Save the length of the hidden data
    length_file = output_file + '.len'
    with open(length_file, 'w') as f:
        f.write(str(len(data)))
    
    print(f"File hidden successfully. Output saved to '{output_file}'.")

def extract_file(combined_file):
    """Extract hidden data from the combined file."""
    combined_file = clean_path(combined_file)
    
    # Check if the combined file and length file exist
    if not os.path.exists(combined_file):
        raise FileNotFoundError(f"Combined file '{combined_file}' not found.")
    
    length_file = combined_file + '.len'
    if not os.path.exists(length_file):
        raise FileNotFoundError(f"Length file '{length_file}' not found.")
    
    # Read the length of the hidden data
    with open(length_file, 'r') as f:
        data_length = int(f.read().strip())
    
    # Read the combined file and extract the hidden data
    with open(combined_file, 'rb') as f:
        content = f.read()
    
    hidden_data = content[-data_length:]
    
    # Save the extracted file in the same directory as the script
    script_directory = os.path.dirname(os.path.abspath(__file__))
    output_file = os.path.join(script_directory, 'extracted-file')
    
    with open(output_file, 'wb') as f:
        f.write(hidden_data)
    
    print(f"File extracted successfully. Output saved to '{output_file}'.")

def main_menu():
    """Display the main menu and handle user input."""
    while True:
        print("\nMain Menu:")
        print("1. Hide a FILE")
        print("2. Extract the FILE")
        print("3. Exit")
        choice = input("Enter your choice (1/2/3): ")
        
        if choice == '1':
            main_file = input("Enter the path to the main file: ").strip()
            data_file = input("Enter the path to the data file: ").strip()
            output_file = input("Enter the path to save the combined file: ").strip()
            try:
                hide_file(main_file, data_file, output_file)
            except Exception as e:
                print(f"Error: {e}")
        elif choice == '2':
            combined_file = input("Enter the path to the combined file: ").strip()
            try:
                extract_file(combined_file)
            except Exception as e:
                print(f"Error: {e}")
        elif choice == '3':
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main_menu()
