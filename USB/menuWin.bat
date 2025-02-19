@echo off
:menu
cls
echo System Tools Menu
echo ================
echo 1. NyanScreen :3
echo 2. Exit

choice /c 12 /n /m "Select option: "
if %errorlevel%==1 start Windows\Prank\Nyan\payload\deploy.bat
if %errorlevel%==2 exit
goto menu
