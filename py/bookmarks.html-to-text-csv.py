from bs4 import BeautifulSoup
import os
import sys
import csv

# Function to read the HTML file
def read_html_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return file.read()
    except FileNotFoundError:
        print(f"\033[91mError: File not found at '{file_path}'\033[0m")
        return None

# Function to extract bookmarks
def extract_bookmarks(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    bookmarks = []

    for link in soup.find_all('a', href=True):
        site_name = link.text.strip()  # Text between <a> and </a>
        site_url = link['href'].strip()  # HREF attribute
        bookmarks.append((site_name, site_url))

    return bookmarks

# Function to save bookmarks to a text file
def save_to_text_file(bookmarks, input_file):
    output_dir = os.path.dirname(input_file)
    output_file = os.path.join(output_dir, "bookmarks.txt")

    try:
        with open(output_file, 'w', encoding='utf-8') as file:
            for site_name, site_url in bookmarks:
                file.write(f"{site_name} - {site_url}\n")
        print(f"\033[92mBookmarks successfully saved to:\033[0m \033[94m{os.path.abspath(output_file)}\033[0m")
    except Exception as e:
        print(f"\033[91mError saving file: {e}\033[0m")

# Function to save bookmarks to a CSV file
def save_to_csv_file(bookmarks, input_file):
    output_dir = os.path.dirname(input_file)
    output_file = os.path.join(output_dir, "bookmarks.csv")

    try:
        with open(output_file, 'w', encoding='utf-8', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(["Site Name", "Site URL"])
            writer.writerows(bookmarks)
        print(f"\033[92mBookmarks successfully saved to:\033[0m \033[94m{os.path.abspath(output_file)}\033[0m")
    except Exception as e:
        print(f"\033[91mError saving file: {e}\033[0m")

# Normalize file paths for Windows
def normalize_path(file_path):
    return file_path.strip('"').strip("'")

# Main function
def main():
    print("\033[96m\n==== Firefox Bookmarks to Text and CSV Converter ====\033[0m")

    # Input: Path to the Firefox-exported HTML file
    html_file = input("\033[93mEnter the path to your Firefox bookmarks HTML file: \033[0m").strip()
    html_file = normalize_path(html_file)

    print("\033[96m\nProcessing...\033[0m")

    # Step 1: Read HTML file
    html_content = read_html_file(html_file)
    if html_content is None:
        return

    # Step 2: Extract bookmarks
    bookmarks = extract_bookmarks(html_content)

    # Step 3: Save bookmarks to text file
    save_to_text_file(bookmarks, html_file)

    # Step 4: Save bookmarks to CSV file
    save_to_csv_file(bookmarks, html_file)

    print("\033[96m\n==== Conversion Completed! ====\033[0m")

# Entry point of the script
if __name__ == "__main__":
    main()
