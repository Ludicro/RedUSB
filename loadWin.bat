@echo off
title Uploading Payloads
color 4F
cls

echo [!] Checking USB drive...
timeout /t 2 /nobreak >nul

:: Detect the USB drive letter and name
for /f "tokens=2 delims==" %%I in ('wmic logicaldisk where "drivetype=2" get deviceid /value') do set USBDrive=%%I
for /f "tokens=2 delims==" %%I in ('wmic logicaldisk where "drivetype=2" get volumename /value') do set USBName=%%I

echo [!] USB drive detected: %USBDrive%
echo [!] USB name: %USBName%

if /i "%USBName%"=="RedUSB" (
    echo [!] Valid RedUSB drive found
    echo [!] Updating USB contents...
    xcopy /E /Y /I "USB\*" "%USBDrive%\"
    echo [!] USB contents updated successfully
) else (
    echo [!] This is not a RedUSB drive
)

timeout /t 3 /nobreak >nul
