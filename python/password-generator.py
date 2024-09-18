#just a simple interactive password generator in python

import random
import string

def generate_password(length, use_uppercase, use_numbers, use_special):
    # Define the character sets
    lowercase_chars = string.ascii_lowercase
    uppercase_chars = string.ascii_uppercase if use_uppercase else ''
    number_chars = string.digits if use_numbers else ''
    special_chars = string.punctuation if use_special else ''
    
    all_chars = lowercase_chars + uppercase_chars + number_chars + special_chars
    
    if not all_chars:
        raise ValueError("No characters available for password generation.")
    
    return ''.join(random.choice(all_chars) for _ in range(length))

def get_valid_length():
    while True:
        try:
            length = int(input("Enter the length of the password (number only): "))
            if length <= 0:
                print("Length must be a positive number. Please try again.")
            else:
                return length
        except ValueError:
            print("Invalid input. Please enter a valid number.")

def get_yes_no_input(prompt):
    while True:
        response = input(prompt).strip().lower()  # Convert to lowercase and strip spaces
        if response in ('y', 'n'):  # Check against lowercase values
            return response == 'y'  # Return True for 'y', False for 'n'
        print("Invalid input. Please enter 'Y' for yes or 'N' for no.")

def display_menu():
    print("\nPassword Generator Menu:")
    print("1. Generate Random Password")
    print("2. Customize Password")
    print("3. Exit")

def main():
    while True:
        display_menu()
        choice = input("Enter your choice (1/2/3): ").strip()

        if choice == '1':
            # Generate a random password with default settings
            password = generate_password(length=12, use_uppercase=True, use_numbers=True, use_special=True)
            print("\nYour random password is:")
            print(password)

        elif choice == '2':
            # Get user input for custom password parameters
            length = get_valid_length()
            use_uppercase = get_yes_no_input("Include uppercase letters? (Y/N): ")
            use_numbers = get_yes_no_input("Include numbers? (Y/N): ")
            use_special = get_yes_no_input("Include special characters? (Y/N): ")

            # Generate the password
            password = generate_password(length, use_uppercase, use_numbers, use_special)
            print("\nYour generated password is:")
            print(password)

        elif choice == '3':
            print("\nExiting the program.")
            break

        else:
            print("\nInvalid choice. Exiting the program.")
            break

if __name__ == "__main__":
    main()
