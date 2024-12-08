@echo off

echo Current user privileges: %userprofile%
echo.
echo Requesting administrative privileges...

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :continue
) else (
    goto :admin
)

:admin
echo.
echo You need to run this batch file as an Administrator.
echo Please grant administrative privileges by selecting "Yes" when prompted.
echo.
powershell -Command "Start-Process '%0' -Verb RunAs"
exit

:continue
echo Administrative privileges confirmed.
echo.
sc stop vgk >Nul
sc stop vgc >Nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v VulnerableDriverBlocklistEnable /t REG_DWORD /d 0x000000
bcdedit /set hypervisorlaunchtype off
reg add HKLM\SYSTEM\CurrentControlSet\Control\CI\Config /v VulnerableDriverBlocklistEnable /t REG_DWORD /d 0x000000
powershell.exe -ExecutionPolicy Bypass -Command "Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
powershell -Command "& {Get-AppxPackage -AllUsers xbox | Remove-AppxPackage}"
sc stop XblAuthManager >Nul
sc stop XblGameSave >Nul
sc stop XboxNetApiSvc >Nul
sc stop XboxGipSvc >Nul
sc delete XblAuthManager >Nul
sc delete XblGameSave >Nul
sc delete XboxNetApiSvc >Nul
sc delete XboxGipSvc >Nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /f  >Nul
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable  >Nul
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disableL  >Nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f  >Nul
set hostspath=%windir%\System32\drivers\etc\hosts >Nul
echo 127.0.0.1 xboxlive.com >> %hostspath% >Nul
echo 127.0.0.1 user.auth.xboxlive.com >> %hostspath% >Nul
echo 127.0.0.1 presence-heartbeat.xboxlive.com >> %hostspath% >Nul
cls
echo Please Restart Your PC
pause>nul
exit