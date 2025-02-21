@echo off
setlocal enabledelayedexpansion

:: Load environment variables from homeInfo.env
for /f "tokens=1,2 delims==" %%A in (%~dp0..\..\..\homeInfo.env) do (
    set %%A=%%B
)

:: Set SSH tunnel parameters
set remote_user=%ServerUser%
set remote_host=%ServerIP%
set remote_port=2222
set ssh_key_path=%DesktopSSHKey%

:: Start reverse SSH tunnel using the private key
echo Establishing reverse shell...
ssh -i %ssh_key_path% -v -N -R %remote_port%:localhost:22 %remote_user%@%remote_host% -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes

:: If SSH connection is lost, script exits
echo Reverse shell closed.
pause
exit
