"""
================================================================================================
Description:

File Extension Categorizer

This script analyzes all files in a given folder and categorizes 
their extensions based on MIME types. It displays categorized 
extensions in a user-friendly format and allows copying all 
unique extensions to the clipboard.

Key Features:
- Categorizes extensions by MIME types (e.g., 'Image', 'Text').
- Displays unique and categorized extensions with color highlights.
- Optionally copies the list of extensions to the clipboard.
- Handles unknown extensions gracefully.

Usage:
1. Run the script and enter the folder path to analyze.
2. View results in the terminal with categorized extensions.
3. Optionally press 'C' to copy extensions to the clipboard.

Dependencies:
- colorama (for colored terminal output)
- pyperclip (for clipboard functionality)

Output:
- Categorized extensions are printed to the terminal.
- Unique extensions can be copied to the clipboard.
================================================================================================
"""

import os
import mimetypes
from collections import defaultdict
from colorama import Fore, Style, init
import pyperclip

# Initialize colorama for color support
init(autoreset=True)

def categorize_extensions(folder_path):
    categorized = defaultdict(set)
    all_extensions = set()

    for root, _, files in os.walk(folder_path):
        for file in files:
            ext = os.path.splitext(file)[1].lower()
            if ext:  # Ensure the file has an extension
                all_extensions.add(ext)
                mime_type, _ = mimetypes.guess_type(file)
                if mime_type:
                    main_type = mime_type.split('/')[0]  # e.g., 'image', 'text'
                    categorized[main_type.capitalize()].add(ext)
                else:
                    categorized["Unknown"].add(ext)

    return categorized, sorted(all_extensions)

def display_results(categorized, all_extensions):
    # Print extensions in a clear and colorful way
    print(f"\n{Fore.YELLOW}*** File Extensions Found ***")
    print()
    print(f"{Fore.CYAN}All unique extensions ({len(all_extensions)}):\n")
    for ext in all_extensions:
        print(f"{Fore.GREEN}- {ext}")
    print("\n")

    print(f"{Fore.YELLOW}*** Categorized Extensions ***\n")
    for category, extensions in categorized.items():
        print(f"{Fore.MAGENTA}{category} ({len(extensions)}):")
        for ext in sorted(extensions):
            print(f"  {Fore.GREEN}- {ext}")
        print()  # Add an empty line after each category

def main():
    # Get folder path from user
    print()
    folder_path = input("Enter the folder path to analyze: ").strip('"\'')

    # Check if the path is valid
    if not os.path.isdir(folder_path):
        print(f"{Fore.RED}Invalid folder path. Please try again.")
        return

    # Categorize extensions
    categorized, all_extensions = categorize_extensions(folder_path)

    # Display results
    display_results(categorized, all_extensions)

    # Prompt to copy extensions to clipboard
    choice = input(f"{Fore.YELLOW}Press 'C' to copy the extensions to clipboard or any other key to exit: ").strip().lower()
    if choice == 'c':
        pyperclip.copy("\n".join(all_extensions))
        print(f"{Fore.GREEN}Extensions copied to clipboard!")
    else:
        print(f"{Fore.CYAN}Exiting. Goodbye!")

if __name__ == "__main__":
    main()
