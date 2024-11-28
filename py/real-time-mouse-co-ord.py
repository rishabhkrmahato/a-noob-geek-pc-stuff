# pip install pyautogui
# install the module first on your pc !

import pyautogui
import time

try:
    while True:
        # Get the current position of the mouse
        x, y = pyautogui.position()
        print(f"Mouse Position: X={x}, Y={y}", end="\r")  # Print on the same line
        time.sleep(0.8)  # change this delay accordingly, done to avoid spamming.
except KeyboardInterrupt:
    print("\nProgram exited!") #Ctrl-C or Close terminal to end.
