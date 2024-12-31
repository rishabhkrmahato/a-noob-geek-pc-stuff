import ctypes
import sys

def main():
    # Check if the script is running as an admin
    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("Not running as admin. Relaunching with admin privileges...")
        # Relaunch the script with admin rights
        ctypes.windll.shell32.ShellExecuteW(
            None, "runas", sys.executable, " ".join(sys.argv), None, 1
        )
        sys.exit()

    # If running as admin, execute the following code
    print("Script is running with admin privileges!")
    input("Press Enter to exit...")

if __name__ == "__main__":
    main()
