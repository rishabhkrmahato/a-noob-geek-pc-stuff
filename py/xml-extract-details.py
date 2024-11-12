# If the input is a URL, please download the XML file first before running this script.
# Note: It may not work as expected if the XML file is minified or compacted, but that's a rare case. Apologies in advance!

# author: rishabhkrm

# Displays the details of the tags input by the user, maintaining the exact order they appear in the XML, with proper formatting and spacing.

import os
import re

# Function to sanitize the filename (remove invalid characters)
def sanitize_filename(filename):
    return re.sub(r'[<>:"/\\|?*]', '_', filename)

def extract_tags(xml_file, tags_to_extract):
    # Extract the file name and path from the XML file
    dir_path = os.path.dirname(xml_file)
    base_name = os.path.basename(xml_file)

    # Remove extra quotes from the file path if present
    if xml_file.startswith('"') and xml_file.endswith('"'):
        xml_file = xml_file[1:-1]

    # Open XML file and parse the data
    with open(xml_file, 'r', encoding='utf-8') as f:
        xml_data = f.read()

    # Create a dictionary to hold the extracted data
    tag_contents = {tag: [] for tag in tags_to_extract}
    
    # Extract data for each tag
    for tag in tags_to_extract:
        pattern = re.compile(f'<{tag}>(.*?)</{tag}>', re.DOTALL)
        tag_contents[tag] = re.findall(pattern, xml_data)

    # Build output filename based on tags
    sanitized_tags = [sanitize_filename(tag) for tag in tags_to_extract]
    output_filename = '-'.join(sanitized_tags) + '-details-from-xml.txt'
    output_filepath = os.path.join(dir_path, output_filename)

    # Write the extracted data to the output file
    with open(output_filepath, 'w', encoding='utf-8') as f:
        # Loop through the length of the first tag's content to manage instances
        num_instances = len(tag_contents[tags_to_extract[0]]) if tag_contents[tags_to_extract[0]] else 0

        for i in range(num_instances):
            # Write a blank line before each set of tag contents (except for the first one)
            if i > 0:
                f.write('\n')

            # Write contents for each tag in the order of user input
            for tag in tags_to_extract:
                if i < len(tag_contents[tag]):  # Handle cases with different numbers of instances
                    f.write(f"\n{tag}: {tag_contents[tag][i]}")
        
        # Write a final blank line after the last instance
        f.write('\n')

    print(f"Output saved to {output_filepath}")

def main():
    # Get the XML file path from user
    xml_file = input('Enter the full path of the XML file (shift-right-click > copy-as path): ')
    
    # Remove any extra quotes if present
    if xml_file.startswith('"') and xml_file.endswith('"'):
        xml_file = xml_file[1:-1]

    # Get the tags to extract from user
    tags_input = input('Enter the tags (comma separated, case-sensitive) to extract: ')
    tags_to_extract = [tag.strip() for tag in tags_input.split(',')]
    
    extract_tags(xml_file, tags_to_extract)

if __name__ == "__main__":
    main()
