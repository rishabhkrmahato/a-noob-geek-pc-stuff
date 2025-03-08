# ================================================================================================
# Description:
# Secure Text Encryption/Decryption Tool
# 
# This Python script provides a secure way to encrypt and decrypt text
# using the Fernet symmetric encryption algorithm. It creates, manages,
# and uses encryption keys stored as files, with a hybrid console and
# GUI interface for better user experience.
#
# Key Features:
# - Generates and manages encryption keys with custom or auto-generated names
# - Provides a dark-themed GUI for text input/output
# - Encrypts any text with strong Fernet encryption
# - Decrypts previously encrypted content with the matching key
# - Copies results to clipboard automatically
# - Validates encrypted text format before attempting decryption
# - Maintains keys as read-only files to prevent accidental modification
#
# Hard-Coded Details:
# - Keys are stored with `.key` extension in the script's directory
# - Uses dark theme colors (#2b2b2b background, #3c3f41 text fields)
# - Input dialog window size is fixed at 400x250 pixels
#
# Steps to Update Hard-Coded Details:
# 1. Modify the color constants in the EncryptionApp class to change the theme
# 2. Adjust KEY_EXTENSION if a different file extension is preferred
# 3. Change window dimensions by updating WINDOW_SIZE and related variables
#
# Usage:
# - Run the script in a Python environment
# - Choose to use an existing key or generate a new one
# - Select encrypt or decrypt operation
# - Input text via the GUI prompt
# - Results are displayed in console and copied to clipboard
#
# Dependencies:
# - Python 3.x
# - cryptography (for Fernet encryption)
# - pyperclip (for clipboard operations)
# - tkinter (for GUI components)
#
# Output:
# - Creates and manages .key files in the script directory
# - Displays original and encrypted/decrypted text in console
# - Copies results to clipboard automatically
#
# Error Handling:
# - Validates encrypted text format before attempting decryption
# - Provides specific error messages for different failure scenarios
# - Handles missing dependencies with clear installation instructions
# - Ensures key files are properly loaded and accessible
#
# Notes:
# - Key files should be backed up securely as they cannot be recovered
# - The same key must be used for both encryption and decryption
# - Text is copied to clipboard for easy transfer to other applications
# ================================================================================================


import os
import sys
import random
import string
import tkinter as tk
from tkinter import simpledialog, messagebox, filedialog
import base64
import re

# Dependency Check
REQUIRED_LIBS = ["cryptography", "pyperclip"]

missing_libs = [lib for lib in REQUIRED_LIBS if not __import__("importlib.util").util.find_spec(lib)]
if missing_libs:
    print("\n[ERROR] Missing dependencies detected!")
    print("Please install them using:")
    print(f"  pip install {' '.join(missing_libs)}")
    sys.exit(1)

# Import dependencies after verification
import pyperclip
from cryptography.fernet import Fernet, InvalidToken

class EncryptionApp:
    # Constants
    KEY_EXTENSION = ".key"
    GUI_BG_COLOR = "#2b2b2b"
    GUI_FG_COLOR = "white"
    GUI_ACCENT_COLOR = "#1e90ff"
    GUI_FONT = ("Arial", 12, "bold")
    TEXT_FONT = ("Arial", 11)
    TEXT_BG_COLOR = "#3c3f41"  # Dark background for text inputs
    TEXT_FG_COLOR = "#e0e0e0"  # Light text for better contrast
    WINDOW_SIZE = "400x250"
    
    def __init__(self):
        self.key = None
        self.key_file = None
    
    def get_input(self, title, prompt):
        """GUI input dialog with consistent dark theme"""
        root = tk.Tk()
        root.withdraw()  # Hide root window

        dialog = tk.Toplevel()
        dialog.title(title)
        
        # Center window
        window_width = 400
        window_height = 250
        screen_width = dialog.winfo_screenwidth()
        screen_height = dialog.winfo_screenheight()
        x = (screen_width - window_width) // 2
        y = (screen_height - window_height) // 2
        dialog.geometry(f"{window_width}x{window_height}+{x}+{y}")

        dialog.configure(bg=self.GUI_BG_COLOR)
        dialog.resizable(False, False)

        label = tk.Label(dialog, text=prompt, fg=self.GUI_FG_COLOR, bg=self.GUI_BG_COLOR, font=self.GUI_FONT)
        label.pack(pady=10)

        # Dark theme for text input
        text_input = tk.Text(dialog, wrap="word", height=6, width=40, font=self.TEXT_FONT, 
                             bg=self.TEXT_BG_COLOR, fg=self.TEXT_FG_COLOR, insertbackground=self.GUI_FG_COLOR)
        text_input.pack(padx=10, pady=5)

        result = []

        def submit():
            result.append(text_input.get("1.0", tk.END).strip())
            dialog.destroy()

        submit_btn = tk.Button(dialog, text="Submit", command=submit, 
                              bg=self.GUI_ACCENT_COLOR, fg=self.GUI_FG_COLOR, font=self.GUI_FONT)
        submit_btn.pack(pady=10)

        dialog.grab_set()
        dialog.wait_window()

        return result[0] if result else None

    def get_key_file(self):
        """List and select a key file or create a new one"""
        key_files = sorted(
            [f for f in os.listdir() if f.endswith(self.KEY_EXTENSION)],
            key=lambda f: os.path.getmtime(f),
            reverse=True
        )

        if key_files:
            print("\n[INFO] Available keys:")
            print()
            for idx, key in enumerate(key_files, 1):
                print(f"  [{idx}] {key}")

            while True:
                print()
                choice = input("Select a key, type 'new' to generate one, or 'custom' to name your key: ").strip()
                if choice.lower() == "new":
                    return self.generate_key()
                elif choice.lower() == "custom":
                    return self.generate_key(custom_name=True)
                elif choice.isdigit() and 1 <= int(choice) <= len(key_files):
                    return key_files[int(choice) - 1]
                else:
                    print("[ERROR] Invalid choice! Please enter a valid number or 'new'/'custom'.")
        else:
            print("[INFO] No existing keys found.")
            choice = input("Type 'new' for auto-generated key name or 'custom' to specify a name: ").strip()
            if choice.lower() == "custom":
                return self.generate_key(custom_name=True)
            else:
                return self.generate_key()

    def generate_key(self, custom_name=False):
        """Generate a new encryption key"""
        if custom_name:
            while True:
                key_name = input("Enter a name for your key (alphanumeric only): ").strip()
                if re.match(r'^[a-zA-Z0-9_-]+$', key_name):
                    key_name = f"{key_name}{self.KEY_EXTENSION}"
                    break
                else:
                    print("[ERROR] Invalid name. Use only letters, numbers, underscores, and hyphens.")
        else:
            key_name = f"secret{''.join(random.choices(string.digits, k=6))}{self.KEY_EXTENSION}"
        
        key = Fernet.generate_key()
        try:
            with open(key_name, "wb") as key_file:
                key_file.write(key)

            # Make read-only to prevent accidental edits
            os.chmod(key_name, 0o444)

            print(f"[INFO] New key generated: {key_name} (read-only)")
            return key_name
        except PermissionError:
            print(f"[ERROR] Cannot create key file. Permission denied.")
            sys.exit(1)
        except Exception as e:
            print(f"[ERROR] Failed to generate key: {str(e)}")
            sys.exit(1)

    def load_key(self, key_file):
        """Load encryption key from file"""
        try:
            with open(key_file, "rb") as f:
                return f.read()
        except FileNotFoundError:
            print(f"\n[ERROR] Key file '{key_file}' not found!")
            sys.exit(1)
        except PermissionError:
            print(f"\n[ERROR] Cannot read key file. Permission denied.")
            sys.exit(1)
        except Exception as e:
            print(f"\n[ERROR] Failed to load key: {str(e)}")
            sys.exit(1)

    def is_valid_fernet_token(self, token):
        """Validate if a string looks like a Fernet token"""
        if not isinstance(token, str):
            return False
            
        # Check reasonable length
        if len(token) < 50:
            return False
            
        # Check if base64 decodable with Fernet-compatible padding
        try:
            # Fernet uses URL-safe base64
            padding_fixed = token + '=' * (-len(token) % 4)
            decoded = base64.urlsafe_b64decode(padding_fixed)
            # Fernet tokens have a minimum structure size
            return len(decoded) > 32
        except Exception:
            return False

    def encrypt_text(self, text):
        """Encrypt text using the loaded key"""
        try:
            cipher = Fernet(self.key)
            encrypted_text = cipher.encrypt(text.encode()).decode()
            pyperclip.copy(encrypted_text)
            messagebox.showinfo("Encryption Success", "Encrypted text copied to clipboard!")

            print("\n[INFO] Original Text:\n" + "-" * 40)
            print(text)
            print("-" * 40)
            print("\n[INFO] Encrypted Text (copied to clipboard):\n" + "=" * 40)
            print(encrypted_text)
            print("=" * 40)
        except Exception as e:
            messagebox.showerror("Encryption Failed", f"An error occurred: {str(e)}")
            print(f"[ERROR] Encryption failed: {str(e)}")

    def decrypt_text(self, text):
        """Decrypt text using the loaded key"""
        # Validate input
        if not self.is_valid_fernet_token(text):
            messagebox.showerror("Validation Failed", 
                                "This doesn't appear to be valid encrypted text. Make sure to copy the entire encrypted string.")
            return
            
        try:
            cipher = Fernet(self.key)
            decrypted_text = cipher.decrypt(text.encode()).decode()
            pyperclip.copy(decrypted_text)
            messagebox.showinfo("Decryption Success", "Decrypted text copied to clipboard!")

            print("\n[INFO] Encrypted Text:\n" + "=" * 40)
            print(text)
            print("=" * 40)
            print("\n[INFO] Decrypted Text:\n" + "-" * 40)
            print(decrypted_text)
            print("-" * 40)
        except InvalidToken:
            messagebox.showerror("Decryption Failed", 
                                "Invalid token or wrong key! Make sure you're using the same key that was used for encryption.")
            print("[ERROR] Decryption failed: Invalid token or wrong key")
        except Exception as e:
            messagebox.showerror("Decryption Failed", f"An error occurred: {str(e)}")
            print(f"[ERROR] Decryption failed: {str(e)}")

    def run(self):
        """Main application loop"""
        self.key_file = self.get_key_file()
        self.key = self.load_key(self.key_file)
        
        print(f"\n[INFO] Using key: {self.key_file}")

        while True:
            print("\n[1] Encrypt Text")
            print("[2] Decrypt Text")
            print("[3] Change Key")
            print("[4] Exit")
            choice = input("Enter choice (1/2/3/4): ").strip()

            if choice == "1":
                text = self.get_input("Encrypt Text", "Enter text to encrypt:")
                if text:
                    self.encrypt_text(text)
            elif choice == "2":
                text = self.get_input("Decrypt Text", "Enter encrypted text to decrypt:")
                if text:
                    self.decrypt_text(text)
            elif choice == "3":
                self.key_file = self.get_key_file()
                self.key = self.load_key(self.key_file)
                print(f"\n[INFO] Changed to key: {self.key_file}")
            elif choice == "4":
                print("\n[INFO] Exiting...")
                break
            else:
                print("[ERROR] Invalid choice! Please enter 1, 2, 3, or 4.")

# Run the application if executed directly
if __name__ == "__main__":
    app = EncryptionApp()
    try:
        app.run()
    except KeyboardInterrupt:
        print("\n[INFO] Program terminated by user.")
    except Exception as e:
        print(f"\n[ERROR] An unexpected error occurred: {str(e)}")
        sys.exit(1)