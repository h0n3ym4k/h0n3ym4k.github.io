REM @echo off

REM Define the path to the text file
set "filepath=C:\Users\user\Downloads\request_reboot.txt"

REM Check if the file exists
if exist "%filepath%" (
    call :acpipowerbutton
    timeout /t 20 /nobreak > NUL
    call :startvm
    timeout /t 10 /nobreak > NUL
) else (
    exit /b
)

REM End of script
exit /b

:acpipowerbutton
echo File exists. Executing acpipowerbutton function...
REM Add your acpipowerbutton commands here
REM "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "g64" acpipowerbutton
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "g64" nic2 null
timeout /t 20 /nobreak > NUL
del "%filepath%"
REM exit /b

:startvm
echo File does not exist. Executing startvm function...
REM Add your startvm commands here
REM "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "g64"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "g64" nic2 bridged "Intel(R) Dual Band Wireless-AC 8265"
timeout /t 10 /nobreak > NUL
REM exit /b