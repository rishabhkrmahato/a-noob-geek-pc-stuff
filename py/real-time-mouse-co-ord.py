import sys
import time
import pyautogui
from tkinter import Tk, Label
from threading import Thread

# Dependency Check Function
def check_dependencies():
    try:
        import keyboard
        import pyperclip
    except ImportError as e:
        print("\n" + "=" * 50)
        print("⚠️  Missing Required Dependencies! ⚠️")
        print("-" * 50)
        print("To install the required modules, run the following command in an elevated terminal:")
        print("\n    pip install pyautogui keyboard pyperclip\n")
        print("-" * 50)
        print("After installation, please relaunch this script.")
        print("=" * 50)
        sys.exit(1)

# Call the dependency check at the start
check_dependencies()

# Function to track mouse coordinates
def track_coordinates():
    try:
        import keyboard
        import pyperclip

        while True:
            # Get the current mouse position
            x, y = pyautogui.position()

            # Update the label with coordinates
            coord_label.config(text=f"Mouse Coordinates:\nX: {x}, Y: {y}", fg="blue")

            # Check for the key combination to copy coordinates
            if keyboard.is_pressed("ctrl+shift+c"):
                coord_text = f"X: {x}, Y: {y}"
                pyperclip.copy(coord_text)  # Copy to clipboard
                coord_label.config(
                    text=f"Copied to Clipboard:\n{coord_text}", fg="green"
                )
                time.sleep(1)  # Briefly show "Copied to Clipboard"
                coord_label.config(text=f"Mouse Coordinates:\nX: {x}, Y: {y}", fg="blue")  # Revert to default color
                time.sleep(0.5)  # Small delay to avoid overlapping key presses

            # Small delay to avoid excessive updates
            time.sleep(0.1)
    except Exception as e:
        # Graceful exit on error
        coord_label.config(text=f"Error: {e}", fg="red")

# Function to handle the GUI setup
def setup_gui():
    # Initialize the Tkinter root window
    root = Tk()
    root.title("Mouse Coordinate Tracker")
    root.geometry("400x220")  # Set the size of the window
    root.resizable(False, False)  # Prevent resizing

    # Instructions Label
    Label(
        root,
        text="Hover your mouse to see the coordinates.\nPress Ctrl+Shift+C to copy to clipboard.",
        font=("Helvetica", 12),
        fg="#555555",
    ).pack(pady=10)

    # Mouse Coordinate Label (dynamic content)
    global coord_label
    coord_label = Label(
        root,
        text="",
        font=("Helvetica", 16, "bold"),
        fg="blue",  # Default text color
    )
    coord_label.pack(pady=20)

    # Run coordinate tracking in a separate thread
    tracking_thread = Thread(target=track_coordinates)
    tracking_thread.daemon = True  # Ensure thread exits with the program
    tracking_thread.start()

    # Run the Tkinter main loop
    root.mainloop()

# Entry point of the program
if __name__ == "__main__":
    setup_gui()
