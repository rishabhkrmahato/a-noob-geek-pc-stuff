@echo off
color 0A

:: Set repository path (make sure to customize this !)
set "repo_path=C:\Users\mahat\Documents\GitHub\a-noob-geek-pc-stuff"

:: Change directory to the repository folder
cd "%repo_path%"

:: Main menu to display files and prompt user
:main_menu
cls
echo ==========================
echo Git Commit Script
echo ==========================
echo.
@REM echo D  - deleted files, 
@REM echo M  - modified files, 
@REM echo ?? - untracked files;
@REM echo.

:: Display git status to show all modified, staged, or untracked files
git status -s

:: List all modified files with numbering and status tracking
setlocal enabledelayedexpansion
set count=1
echo.
echo Select files to commit - separated by spaces - (e.g., 1 3 5):

:: Show files with numbers
for /f "tokens=1,* delims= " %%i in ('git status -s') do (
    set "status=%%i"
    set "file_path=%%j"
    
    :: Echo file status and path correctly
    if "!status!"=="??" (
        echo !count!: UNTRACKED - !file_path!
    ) else if "!status!"=="D" (
        echo !count!: DELETED - !file_path!
    ) else if "!status!"=="M" (
        echo !count!: MODIFIED - !file_path!
    )

    set "file!count!=!file_path!"
    set /a count+=1
)

:: Get user selection
echo.
set /p "selection=Enter file numbers to commit, or 'done' to finalize and push: "

:: If the user typed 'done', proceed to push
if /i "%selection%" == "done" goto push_changes

:: Loop through each selected file number
set "selected_files="
for %%s in (%selection%) do (
    if defined file%%s (
        set "selected_files=!selected_files! !file%%s!"
        git add "!file%%s!"
        echo Added: !file%%s!
    ) else (
        echo Invalid selection '%%s'. Skipping.
    )
)

:: Prompt for commit message for the selected files
set /p "commit_msg=Enter commit message for selected files: "
git commit -m "!commit_msg!"
echo Committed selected files with message: "!commit_msg!"
pause

goto main_menu

:push_changes
:: Confirm and push all changes
git push origin main
echo.
echo All changes have been pushed successfully!
echo Opening rishabhkrmahato github repo . . .

:: Wait before closing terminal
timeout /t 2

:: Open GitHub repo and close terminal
start https://github.com/rishabhkrmahato/a-noob-geek-pc-stuff
exit
