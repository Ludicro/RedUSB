@echo off
title Deploying System Update
color 4F
cls
echo [!] Deploying Lock Screen...
timeout /t 2 /nobreak >nul

:: Detect the USB drive letter
echo [!] Detecting USB drive...
for /f "tokens=2 delims==" %%I in ('wmic logicaldisk where "drivetype=2" get deviceid /value') do set USBDrive=%%I
echo [!] USB drive detected: %USBDrive%

:: Verify the source files exist on the USB drive
if not exist "%USBDRIVE%\Windows\Prank\Nyan\payload\nyan_glitch.gif" (
    echo [!] Error: nyan_glitch.gif not found on USB drive.
    exit /b
)

if not exist "%USBDRIVE%\Windows\Prank\Nyan\payload\lockscreen.hta" (
    echo [!] Error: lockscreen.hta not found on USB drive.
    exit /b
)

if not exist "%USBDRIVE%\Windows\Prank\Nyan\payload\launcher.vbs" (
    echo [!] Error: launcher.vbs not found on USB drive.
    exit /b
)

if not exist "%USBDRIVE%\Windows\Prank\Nyan\payload\jk.bat" (
    echo [!] Error: jk.bat not found on USB drive.
    exit /b
)

:: Copy prank files to C:\Windows\Temp
echo [!] Deploying prank files...
copy /Y "%USBDRIVE%\Windows\Prank\Nyan\payload\nyan_glitch.gif" "C:\Windows\Temp\nyan_glitch.gif"
copy /Y "%USBDRIVE%\Windows\Prank\Nyan\payload\lockscreen.hta" "C:\Windows\Temp\lockscreen.hta"
copy /Y "%USBDRIVE%\Windows\Prank\Nyan\payload\launcher.vbs" "C:\Windows\Temp\launcher.vbs"

:: Copy cleanup file to user's desktop
copy /Y "%USBDRIVE%\Windows\Prank\Nyan\payload\jk.bat" "%USERPROFILE%\Desktop\jk.bat"


:: Run the prank
echo [!] Running prank...

:: Switch the display to be PC only
start Displayswitch.exe /internal

:: Run the HTA file
wscript.exe "C:\Windows\Temp\launcher.vbs"

:: Wait for user to restart the machine
echo [!] Please restart the computer to end the prank...
pause
exit
