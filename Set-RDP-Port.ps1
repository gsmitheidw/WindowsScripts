# Set RDP port to whatever you wish:
$RDPPort = '33899'

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP\" -Name PortNumber -Value $RDPPort
New-NetFirewallRule -DisplayName "RDP Port $RDPPort" -Direction Inbound –LocalPort $RDPPort -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "RDP Port $RDPPort" -Direction Inbound –LocalPort $RDPPort -Protocol UDP -Action Allow
Restart-Service termservice -Force
Write-host "RDP port has been set to $RDPPort "
