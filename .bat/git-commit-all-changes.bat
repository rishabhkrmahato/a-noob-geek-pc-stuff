:: ================================================================================================
:: Description:
:: Git Auto Commit & Push
:: 
:: This batch script automates the process of staging, committing, 
:: and pushing changes to a GitHub repository.
::
:: Key Features:
:: - Navigates to a specified GitHub repository folder.
:: - Prompts the user for a commit message.
:: - Executes `git add`, `git commit`, and `git push` in sequence.
:: - Displays confirmation upon successful push.
::
:: Hard-Coded Details:
:: - `"C:\Users\mahat\Documents\GitHub\a-noob-geek-pc-stuff"` → Path to the local Git repository.
::
:: Steps to Update Hard-Coded Details:
:: 1. Modify the `cd` command to point to your local Git repository path.
:: 2. Change `origin main` if your branch name is different (e.g., `master`).
::
:: Usage:
:: - Run the script in a Git-enabled command prompt.
:: - Enter a commit message when prompted.
:: - The script will automatically push changes to GitHub.
::
:: Dependencies:
:: - Git must be installed and available in the system PATH.
::
:: Output:
:: - Displays success message after pushing changes.
::
:: Error Handling:
:: - Exits if the repository path is invalid.
:: - Shows Git error messages if commit or push fails.
::
:: Notes:
:: - Ensure you are authenticated with GitHub (e.g., via SSH or stored credentials).
:: ================================================================================================


@echo off

cd /d "C:\Users\mahat\Documents\GitHub\a-noob-geek-pc-stuff" || (echo Invalid repo path. & pause & exit /b)

set /p commit_msg=Enter commit message: 
git add . && git commit -m "%commit_msg%" && git push origin main && echo Commit pushed!
pause
