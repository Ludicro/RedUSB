@echo off
title System Restore
color 2F
cls
echo [!] Restoring system settings...
timeout /t 2 /nobreak >nul


:: Kill the HTA process and restore display
taskkill /F /IM mshta.exe
start Displayswitch.exe /extend

:: Kill script to re-enable keys (Optional: You can manually stop the script or add a cleanup here)
taskkill /F /IM powershell.exe

:: Clean up files
del "C:\Windows\Temp\nyan_glitch.gif"
del "C:\Windows\Temp\lockscreen.hta"
del "C:\Windows\Temp\launcher.vbs"
del "C:\Windows\Temp\keyLock.ps1"
del "%USERPROFILE%\Desktop\jk.bat"


echo [!] Prank undone, system restored.
pause
exit
