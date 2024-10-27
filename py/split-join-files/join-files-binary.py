def join_split_files():
    # Ask for the full file name including extension
    full_file_name = input("Enter the full file name (with extension) of the original file: ")
    
    # Derive the base file name without the extension
    base_file_name = full_file_name.rsplit('.', 1)[0]
    
    # Get the number of parts to join
    num_parts = int(input("Enter the number of parts: "))

    # Check if output file already exists
    if os.path.exists(full_file_name):
        overwrite = input(f"File '{full_file_name}' already exists. Overwrite? (y/n): ")
        if overwrite.lower() != 'y':
            print("Operation cancelled.")
            return

    # Step 1: Open the output file in binary write mode
    with open(full_file_name, 'wb') as output_file:
        for i in range(1, num_parts + 1):
            part_file_name = f"{base_file_name}_part{i}{full_file_name[full_file_name.rfind('.'):]}"

            try:
                with open(part_file_name, 'rb') as part_file:
                    output_file.write(part_file.read())
                    print(f"Added part '{part_file_name}' to '{full_file_name}'")
            except FileNotFoundError:
                print(f"File not found: {part_file_name}")
                return  # Exit if any part file is missing

    print(f"Files joined into '{full_file_name}' successfully!")

# Import os for file existence check
import os

# Run the join function
join_split_files()
