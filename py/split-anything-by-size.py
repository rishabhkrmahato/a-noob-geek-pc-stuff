import os
import subprocess
import shlex
import sys
import ctypes

def display_banner():
    banner = """
    ***********************************
    *         7z TAR Splitter         *
    ***********************************
    """
    print(banner)

def check_7z_installed():
    try:
        # Check if 7z is installed and in PATH
        result = subprocess.run("7z", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if "7-Zip" in result.stdout:
            print("7z is already installed and available in PATH.\n")
            return True
    except FileNotFoundError:
        pass

    return False

def install_7z():
    print("7z not found. Preparing to install it via Chocolatey.\n")

    # Relaunch as admin if not already running as admin
    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("Restarting script as Administrator...")
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit()

    # Install Chocolatey and 7z
    try:
        print("Installing Chocolatey...")
        subprocess.run(
            '@"%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" '
            '-NoProfile -InputFormat None -ExecutionPolicy Bypass '
            '-Command "Set-ExecutionPolicy Bypass -Scope Process -Force; '
            '[System.Net.ServicePointManager]::SecurityProtocol = '
            '[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; '
            'iex ((New-Object System.Net.WebClient).DownloadString(\'https://chocolatey.org/install.ps1\'))"',
            shell=True,
            check=True,
        )
        print("Chocolatey installed successfully.\n")

        print("Installing 7z...")
        subprocess.run("choco install 7zip -y", shell=True, check=True)
        print("7z installed successfully.\n")

    except subprocess.CalledProcessError as e:
        print(f"An error occurred while installing 7z: {e}")
        sys.exit()

def get_user_inputs():
    # Get user inputs for split size, destination file, and file/directory paths
    split_size = input("Enter the split size in MB: ").strip()
    print()

    destination_file = input("Enter the destination file name/path: ").strip()
    print()

    print("Drag and drop files/directories here OR type all paths separated by spaces (eg. \"C:\\Path1\" \"C:\\Path2\").")
    
    paths = input("Paths: ").strip()
    # Convert drag-and-drop input to a list of paths
    sanitized_paths = shlex.split(paths)  # Handles quotes around paths
    return split_size, destination_file, sanitized_paths

def execute_7z_command(split_size, destination_file, paths):
    # Sanitize and normalize all user-provided paths
    sanitized_paths = []
    for path in paths:
        # Remove surrounding quotes and normalize to absolute path
        cleaned_path = os.path.abspath(path.strip('"\''))  # Strip both single and double quotes
        sanitized_paths.append(f'"{cleaned_path}"')  # Add double quotes around cleaned path for Windows

    # Join sanitized paths into a single string
    paths_str = ' '.join(sanitized_paths)

    # Sanitize and quote the destination file
    destination_file = os.path.abspath(destination_file.strip('"\''))  # Clean destination path

    # Construct the 7z command
    command = f'7z a -ttar -v{split_size}m "{destination_file}" {paths_str}'

    print("\nExecuting command:")
    print(command)

    try:
        # Run the 7z command and capture output
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"An error occurred: {e}")
        print(e.stderr)

def main():
    display_banner()

    # Check if 7z is installed, and install if necessary
    if not check_7z_installed():
        install_7z()

    split_size, destination_file, paths = get_user_inputs()
    execute_7z_command(split_size, destination_file, paths)
    print("\nCompression task completed!")

if __name__ == "__main__":
    main()
