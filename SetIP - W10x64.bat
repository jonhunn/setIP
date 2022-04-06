@echo off 
echo Choose: 
echo [1] Set up a line computer
echo [2] Set up a manager or PC workstation
echo [3] Reset to DHCP
echo. 


:choice 
echo Please select an option:
SET /P C=[1,2 3]? 
for %%? in (1) do if /I "%C%"=="%%?" goto A 
for %%? in (2) do if /I "%C%"=="%%?" goto B 
for %%? in (3) do if /I "%C%"=="%%?" goto C
goto choice 


:A 
@echo off 
color 03
echo 	You are currently setting up a line computer.
echo Excluding the final octet, enter the base range for the site that you
echo are working on (eg 10.38.129):
set /p BS_RG=
echo You have entered: %BS_RG% is this correct? (Y/N)
:choice 
SET /P C=[y,n]?
FOR %%? in (y,Y) do if /I "%C%"=="%%?" goto A1
FOR %%? in (n,N) do if /I "%C%"=="%%?" goto A


:A1
@echo off 
echo For which line are you setting up?
echo 		Use two numerical digits (eg. Line 2 = 02)
set /p LN_NM=
echo You have entered: %LN_NM% is this correct? (Y/N)
SET /P C=[y,n]?


:choice 
FOR %%? in (y,Y) do if /I "%C%"=="%%?" goto A2
FOR %%? in (n,N) do if /I "%C%"=="%%?" goto A1


:A2
@echo off 
echo "Setting Static IP Information" 

netsh interface ip set address "Ethernet" static %BS_RG%.2%LN_NM% 255.255.255.0 %BS_RG%.1 
netsh interface ipv4 set dns "Ethernet" static %BS_RG%.25
netsh interface ipv4 add dns "Ethernet" 168.254.1.1 index=2


shutdown -s -t 0 


ECHO Here are the new settings for %computername%: 
netsh int ip show config 
shutdown -s -t 0
pause 
goto end


:B 
@echo off 
color 0A
echo 	You are currently setting up a Manager/PC computer.
echo Excluding the final octet, enter the base range for the site that you
echo are working on (eg 10.38.129):
set /p BS_RG=
echo You have entered: %BS_RG% is this correct? (Y/N)


:choice 
SET /P C=[y,n]?
FOR %%? in (y,Y) do if /I "%C%"=="%%?" goto B1
FOR %%? in (n,N) do if /I "%C%"=="%%?" goto B


:B1
@echo off 
echo Are you setting up a manager's machine?
SET /P C=[y,n]?
:choice 
FOR %%? in (y,Y) do if /I "%C%"=="%%?" goto B3
FOR %%? in (n,N) do if /I "%C%"=="%%?" goto B2


:B2
@echo off 
echo Settings for PC's machine are updating:
netsh interface ip set address "Ethernet" static %BS_RG%.131 255.255.255.0 %BS_RG%.1 
netsh interface ipv4 set dns "Ethernet" static %BS_RG%.225
netsh interface ipv4 add dns "Ethernet" 168.254.1.1 index=2
shutdown -s -t 0

pause 
goto end


:B3
@echo off
echo Settings for Manager's machine are updating:
netsh interface ip set address "Ethernet" static %BS_RG%.130 255.255.255.0 %BS_RG%.1
netsh interface ipv4 set dns "Ethernet" static %BS_RG%.25
netsh interface ipv4 add dns "Ethernet" 168.254.1.1 index=2


shutdown -s -t 0
pause 
goto end

:C 
@ECHO OFF 
color 09
ECHO You are currently resetting the IP Address and Subnet Mask for DHCP 
netsh int ip set address name = "Ethernet" source = dhcp
netsh interface ipv4 set dns "Ethernet" source = dhcp

ipconfig /renew

ECHO Here are the new settings for %computername%: 
netsh int ip show config
shutdown -s -t 0
pause 
goto end 
:end