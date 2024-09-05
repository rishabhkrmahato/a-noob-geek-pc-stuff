# If Windows remains unchanged, without reinstallation or any other modifications, it maintains a record of the initial boot time in both the registry and the Windows event log

import winreg  # Import the Windows registry module
import datetime  # Import datetime for time conversion

def get_install_date():
    """
    This function reads the Windows installation date from the registry.
    The registry key contains the install date in Unix time (seconds since 1970).
    """
    try:
        # Open the registry key where the install date is stored
        key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Microsoft\Windows NT\CurrentVersion")
        
        # Query the 'InstallDate' value (Unix timestamp)
        install_date, _ = winreg.QueryValueEx(key, "InstallDate")
        
        # Close the registry key after reading
        winreg.CloseKey(key)
        
        # Convert the Unix timestamp to a human-readable date and time
        install_time = datetime.datetime.fromtimestamp(install_date)
        return install_time

    except Exception as e:
        # If any error occurs (e.g., the key is missing), print the error message
        return f"Error: {e}"

# Call the function and store the result
first_boot_date_time = get_install_date()

# Output the result to the console
print("First Windows Boot Date & Time:", first_boot_date_time)

# If needed, you can also save the output to a file by uncommenting the next lines:
# with open("first_boot_time.txt", "w") as f:
#     f.write(f"First Windows Boot Date & Time: {first_boot_date_time}\n")
