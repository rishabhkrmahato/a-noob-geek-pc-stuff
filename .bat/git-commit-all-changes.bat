@echo off
:: Ask for commit message
set /p commit_msg=Enter your commit message: 

:: Navigate to your repository folder
cd "C:\Users\mahat\Documents\GitHub\a-noob-geek-pc-stuff"
:: ***change this to your own "repo folder" location***

:: Stage all changes
git add .

:: Commit changes with the message
git commit -m "%commit_msg%"

:: Push changes to the 'main' branch
:: you will need to verify and authorise git on your machine for the first time you use this
git push origin main

echo Commit and push completed successfully!
pause
