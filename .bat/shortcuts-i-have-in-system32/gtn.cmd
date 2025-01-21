@echo off
for %%i in (%*) do (
	echo.
    echo Generating thumbnails for "%%~i"
    "C:\Program Files (x86)\K-Lite Codec Pack\MPC-HC\mpc-hc.exe" /thumbnails "%%~i"
    echo Done with "%%~i"
)
