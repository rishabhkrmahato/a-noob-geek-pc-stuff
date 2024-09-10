@echo off
:: Script to update all packages for Chocolatey, Scoop, and pip

echo Updating Chocolatey packages...
choco upgrade all --yes

echo.
echo Updating Scoop packages...
scoop update * --force

echo.
echo Updating pip packages...
pip list --outdated --format=freeze | findstr /v "pip==" | findstr /v "setuptools==" > outdated.txt
for /f "delims==" %%i in (outdated.txt) do pip install --upgrade %%i
del outdated.txt

echo.
echo All updates are complete!
pause
exit /b
