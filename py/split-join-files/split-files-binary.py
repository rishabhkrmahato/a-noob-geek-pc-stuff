def split_file():
    # Ask the user for file name and number of parts
    file_path = input("Enter the file name (with extension): ")

    try:
        # Step 1: Read the file in binary mode
        with open(file_path, 'rb') as f:
            data = f.read()
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return  # Exit if the file does not exist

    num_parts = int(input("Enter the number of parts to split into: "))

    # Step 2: Convert to a binary string
    binary_data = ''.join(format(byte, '08b') for byte in data)

    # Step 3: Calculate the chunk size in bits
    chunk_size = len(binary_data) // num_parts

    # Step 4: Split the binary data into specified number of parts
    parts = [binary_data[i * chunk_size: (i + 1) * chunk_size] for i in range(num_parts - 1)]
    parts.append(binary_data[(num_parts - 1) * chunk_size:])  # Last part may be smaller

    # Step 5: Save each part as a new file
    for i, part in enumerate(parts):
        part_file_name = f"{file_path.split('.')[0]}_part{i + 1}.{file_path.split('.')[-1]}"
        
        # Convert binary string back to bytes
        byte_data = bytes(int(part[j:j + 8], 2) for j in range(0, len(part), 8))
        
        # Write to new part file
        with open(part_file_name, 'wb') as part_file:
            part_file.write(byte_data)
        
        print(f"Written {len(byte_data)} bytes to '{part_file_name}'")

    print(f"File '{file_path}' split into {num_parts} parts successfully!")

# Run the function
split_file()
