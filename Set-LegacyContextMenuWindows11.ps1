<#
. Restore Right-Click context menu in Windows explorer to Windows 11 from previous Windows 10
. 
#>
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Value "" -Force
# Explorer process will be automaticlly respawned:
Get-Process explorer | Stop-Process

# Reinstate Windows 11 default:
# Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
# Get-Process explorer | Stop-Process
