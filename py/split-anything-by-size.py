import os
import subprocess
import sys
import re
from pathlib import Path

def check_7z():
    """Check if 7z is installed and in PATH."""
    try:
        subprocess.run(["7z"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
        print("7z is installed and running, continuing...")
    except FileNotFoundError:
        print("7z not found! Installing it now...")
        install_7z()

def install_7z():
    """Install 7z using Chocolatey."""
    if not is_admin():
        print("Restarting as admin to install 7z...")
        relaunch_as_admin()
    try:
        subprocess.run(["choco"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    except FileNotFoundError:
        print("Chocolatey not found, installing Chocolatey...")
        install_choco()

    print("Installing 7z-full via Chocolatey...")
    subprocess.run(["choco", "install", "7zip", "-y"], check=True)
    print("7z installed successfully!")

def install_choco():
    """Install Chocolatey."""
    choco_script = r"""
    %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    """
    subprocess.run(choco_script, shell=True, check=True)

def is_admin():
    """Check if the script is running as admin."""
    try:
        return os.getuid() == 0
    except AttributeError:
        import ctypes
        return ctypes.windll.shell32.IsUserAnAdmin() != 0

def relaunch_as_admin():
    """Relaunch the script with admin privileges."""
    import ctypes
    script = os.path.abspath(sys.argv[0])
    params = ' '.join([f'"{arg}"' for arg in sys.argv[1:]])
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, f'"{script}" {params}', None, 1)
    sys.exit()

def get_input(prompt):
    """Helper to handle paths and strip unnecessary quotes."""
    return Path(input(prompt).strip().strip('"').strip("'"))

def main():
    """Main function to check prerequisites and split files."""
    check_7z()

    # Input file/folder path
    print()
    input_path = get_input("Enter the FILE/FOLDER path to Split: ")
    if not input_path.exists():
        print(f"Error: The provided path '{input_path}' does not exist!")
        sys.exit(1)

    # Input split size
    try:
        print()
        split_size = int(input("Enter the SPLIT SIZE in MB (e.g., 2000): "))
    except ValueError:
        print("Error: Split size must be an integer.")
        sys.exit(1)

    # Input destination folder
    print()
    dest_folder = get_input("Enter the OUTPUT folder path: ")
    dest_folder.mkdir(parents=True, exist_ok=True)

    # Determine the base name
    base_name = input_path.stem if input_path.is_file() else input_path.name
    output_name = dest_folder / base_name

    # 7z tar split command
    print()
    command = [
        "7z", "a", "-ttar", f"-v{split_size}m", f"{output_name}.tar", str(input_path)
    ]

    print("Running command:", " ".join(command))
    try:
        subprocess.run(command, check=True)
        print()
        print("Splitting completed successfully!")

        # List output files
        print()
        print(f"Listing OUTPUT files: ")
        print()        
        # print(f"Listing .tar.xxx files in {dest_folder}:")
        for file in dest_folder.iterdir():
            if re.match(r".*\.tar\.\d{3}$", file.name):  # Matches files like .tar.001, .tar.002, etc.
                print(file)                
        # output_files = sorted(dest_folder.glob(f"{base_name}.tar.*"))
        # print()
        # print("Generated files:")
        # for file in output_files:
        #     print(file)
    except subprocess.CalledProcessError as e:
        print(f"Error during splitting: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
