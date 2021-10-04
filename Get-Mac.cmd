@echo off
:: Ask user for the target computer name
set /p Input=Computer Name? 
echo %Input% : >> lab.txt
ipconfig /all | find "Phy" >> lab.txt
ipconfig /all | find "IPv4" >> lab.txt
echo current hostname: >> lab.txt
hostname >> lab.txt
type lab.txt
pause
:: logout
shutdown /l 