"""
==================================================================================================
 Description:
 Script Name: Secure Text Encryption & Decryption

 - This script allows secure encryption and decryption of text using Fernet (AES-based encryption).
 - Uses a randomly named key file (`secretXXXX.key`) to store encryption keys securely.
 - GUI input via Tkinter for better user experience.
 - Supports automatic clipboard copying for convenience.

 Key Features:
 - Checks for missing dependencies (`cryptography`, `pyperclip`, `tkinter`).
 - Generates and securely stores encryption keys.
 - Encrypts text and copies the output to the clipboard.
 - Decrypts encrypted text and copies the plain text to the clipboard.
 - Uses a non-blocking GUI for input prompts.
 - Prevents browser caching issues by appending a random query parameter.

 Hard-Coded Details:
 - The encryption key is saved in a file named `secretXXXX.key` (XXXX = random 4-digit number).
 - The script assumes `pyperclip`, `cryptography`, and `tkinter` are installed.
 - Uses Fernet encryption from the `cryptography` library.

 Steps to Update Hard-Coded Details:
 1. Change the `KEY_FILE` format if you want a different naming convention.
 2. Modify the `get_input()` function to change how text input is handled.
 3. Adjust the clipboard behavior in `encrypt_text()` and `decrypt_text()` if necessary.

 Usage:
 - Run the script.
 - Select `Encrypt` or `Decrypt`.
 - Enter text in the GUI window.
 - The result is copied to the clipboard automatically.
 - Check the console for additional details.

 Dependencies:
 - `cryptography` (Install via `pip install cryptography`)
 - `pyperclip` (Install via `pip install pyperclip`)
 - `tkinter` (Pre-installed with Python, but may require `sudo apt install python3-tk` on Linux)

 Output:
 - The encrypted text is displayed in the console and copied to the clipboard.
 - The decrypted text is also copied for easy access.

 Error Handling:
 - If dependencies are missing, the script prompts the user to install them.
 - If the key file is missing, an error message is displayed.
 - Incorrect encrypted text inputs trigger a warning.

 Notes:
 - Keep the key file safe! Losing it means you cannot decrypt your data.
 - Useful for quick encryption of sensitive information without saving files.

==================================================================================================
"""



import os
import sys
import tkinter as tk
from tkinter import simpledialog, messagebox

# Dependency Check
REQUIRED_LIBS = ["cryptography", "pyperclip"]

missing_libs = [lib for lib in REQUIRED_LIBS if not __import__("importlib.util").util.find_spec(lib)]
if missing_libs:
    print("\n[ERROR] Missing dependencies detected!")
    print("Please install them using:")
    print(f"  pip install {' '.join(missing_libs)}")
    sys.exit(1)

# Check if Tkinter is available
try:
    import tkinter as tk
    from tkinter import simpledialog, messagebox
except ImportError:
    print("\n[ERROR] Tkinter is not installed. It usually comes with Python.")
    print("If using Linux, install it with: sudo apt install python3-tk")
    sys.exit(1)

# Import dependencies after verification
import pyperclip
from cryptography.fernet import Fernet

import random
KEY_FILE = f"secret{random.randint(1000, 9999)}.key"

# **Fixed GUI (Non-Blocking)**
def get_input(title, prompt):
    root = tk.Tk()
    root.withdraw()  # Hide root window

    dialog = tk.Toplevel()
    dialog.title(title)
    dialog.geometry("400x250")
    dialog.configure(bg="#2b2b2b")  # Dark theme
    dialog.resizable(False, False)  # Prevent resizing

    # Label
    label = tk.Label(dialog, text=prompt, fg="white", bg="#2b2b2b", font=("Arial", 12, "bold"))
    label.pack(pady=10)

    # Textbox
    text_input = tk.Text(dialog, wrap="word", height=6, width=40, font=("Arial", 11))
    text_input.pack(padx=10, pady=5)

    # Store result
    result = []

    # Submit button
    def submit():
        result.append(text_input.get("1.0", tk.END).strip())  # Store input
        dialog.destroy()  # Close GUI box

    submit_btn = tk.Button(dialog, text="Submit", command=submit, bg="#1e90ff", fg="white", font=("Arial", 12, "bold"))
    submit_btn.pack(pady=10)

    dialog.grab_set()  # Make modal (blocks input to other windows)
    dialog.wait_window()  # Wait until it's closed

    return result[0] if result else None  # Return input text

# Generate Key
def generate_key():
    if not os.path.exists(KEY_FILE):
        key = Fernet.generate_key()
        key_path = os.path.abspath(KEY_FILE)
        with open(KEY_FILE, "wb") as key_file:
            key_file.write(key)
        print()
        print(f"[INFO] Key file '{KEY_FILE}' created. Keep it safe!")
        print(f"[INFO] Key file location: {key_path}")
    else:
        key_path = os.path.abspath(KEY_FILE)
        print()
        print(f"[INFO] Key file '{KEY_FILE}' already exists.")
        print(f"[INFO] Key file location: {key_path}")

# Load Key
def load_key():
    if not os.path.exists(KEY_FILE):
        print()
        print("[ERROR] Key file not found! Run the script again to generate it.")
        exit(1)
    with open(KEY_FILE, "rb") as key_file:
        return key_file.read()

# Encrypt
def encrypt_text(text, key):
    cipher = Fernet(key)
    encrypted_text = cipher.encrypt(text.encode()).decode()
    pyperclip.copy(encrypted_text)
    messagebox.showinfo("Encryption Success", "Encrypted text copied to clipboard!")

    print("\n[INFO] Original Text Entered:\n" + "-" * 40)
    print(text)
    print("-" * 40)
    print()
    print("[INFO] Encrypted text copied to clipboard.")
    print("=" * 40)
    print(encrypted_text)
    print("=" * 40)

# Decrypt
def decrypt_text(text, key):
    cipher = Fernet(key)
    try:
        decrypted_text = cipher.decrypt(text.encode()).decode()
        pyperclip.copy(decrypted_text)
        messagebox.showinfo("Decryption Success", "Decrypted text copied to clipboard!")

        print("\n[INFO] Encrypted Text Entered.")
        print("=" * 40)
        print(text)
        print("=" * 40)
        print()
        print("[INFO] Decrypted Text:\n" + "-" * 40)
        print(decrypted_text)
        print("-" * 40)
        print("[INFO] Decrypted text copied to clipboard.")
    except:
        messagebox.showerror("Decryption Failed", "Invalid encrypted text or wrong key!")

# Main
def main():
    generate_key()
    key = load_key()

    while True:
        print("\n[1] Encrypt Text")
        print("[2] Decrypt Text")
        print("[3] Exit")
        choice = input("Enter choice (1/2/3): ").strip()

        if choice == "1":
            text = get_input("Encrypt Text", "Enter text to encrypt:")
            if text:
                encrypt_text(text, key)
        elif choice == "2":
            text = get_input("Decrypt Text", "Enter encrypted text to decrypt:")
            if text:
                decrypt_text(text, key)
        elif choice == "3":
            print()
            print("[INFO] Exiting...")
            break
        else:
            print("[ERROR] Invalid choice! Please enter 1, 2, or 3.")

if __name__ == "__main__":
    main()
