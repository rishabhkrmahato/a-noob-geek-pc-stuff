"""
================================================================================================
Description:
Secure Text Encryptor & Decryptor

This script provides a simple encryption and decryption tool using 
the `cryptography` library (Fernet). It securely encrypts user-inputted 
text and copies the result to the clipboard.

Key Features:
- Generates and stores a unique encryption key (`secret.key`).
- Encrypts user-provided text and copies it to the clipboard.
- Decrypts encrypted text and restores the original message.
- Provides a graphical input box for text entry using Tkinter.
- Uses `pyperclip` to automatically copy results to the clipboard.

Hard-Coded Details:
- `KEY_FILE = "secret.key"` → Stores the encryption key.
- Uses `Fernet` encryption from the `cryptography` module.
- Displays messages via Tkinter pop-ups for better user experience.

Steps to Update Hard-Coded Details:
1. Modify `KEY_FILE` if a different key storage location is preferred.
2. Adjust `Fernet` settings for different encryption needs.
3. Change Tkinter GUI properties for a customized user interface.

Usage:
- Run the script and select an option from the menu:
  [1] Encrypt Text → Enter text and copy encrypted output.
  [2] Decrypt Text → Enter encrypted text and retrieve original content.
  [3] Exit → Close the script.
- The encryption key is generated and stored automatically on first use.

Dependencies:
- Python modules: `cryptography`, `pyperclip`, `tkinter`
- Install missing dependencies using:
  `pip install cryptography pyperclip`

Output:
- Encrypted or decrypted text copied to the clipboard.
- Console logs provide details on each operation.

Error Handling:
- Checks for missing dependencies and provides installation instructions.
- Prevents encryption/decryption errors with validation and exception handling.

Notes:
- Losing `secret.key` means encrypted data cannot be recovered.
- Only use this tool on trusted systems to avoid security risks.
================================================================================================
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

KEY_FILE = "secret.key"

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
        with open(KEY_FILE, "wb") as key_file:
            key_file.write(key)
        print()
        print(f"[INFO] Key file '{KEY_FILE}' created. Keep it safe!")
    else:
        print()
        print(f"[INFO] Key file '{KEY_FILE}' already exists.")

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
