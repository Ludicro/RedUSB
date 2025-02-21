@echo off

:: Check if script is running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:: Load environment variables from homeInfo.env
for /f "tokens=1,2 delims==" %%A in (%~dp0..\..\..\homeInfo.env) do (
    set %%A=%%B
)

:: Set SSH tunnel parameters from environment variables
set remote_user=%ServerUser%
set remote_host=%ServerIP%
set remote_port=2222
set ssh_key_path=%DesktopSSHKey%

:: Create the reverse SSH script
set scriptpath=%TEMP%\ludicro_Rssh.bat
echo @echo off > "%scriptpath%"
echo :loop >> "%scriptpath%"
echo ssh -i %ssh_key_path% -N -R %remote_port%:localhost:22 %remote_user%@%remote_host% -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes >> "%scriptpath%"
echo timeout /t 10 >> "%scriptpath%"
echo goto loop >> "%scriptpath%"

:: Create the scheduled task
set taskname=LudicroRSSHTask
schtasks /create /tn "%taskname%" /tr "%scriptpath%" /sc onstart /ru SYSTEM /RL HIGHEST /F

:: Start the task immediately
schtasks /run /tn "%taskname%"

echo Task %taskname% created and started!
pause
exit