<#
.Synopsis
   Configure fslogix for Windows Virtual Desktop, requires local admin priviliges & internet access. 
   Graham Smith 2020
.DESCRIPTION
   1. Downloads fslogix, extracts zip, runs install passively, cleans up downloaded files.
   2. Configures required settings (https://docs.microsoft.com/en-us/fslogix/configure-profile-container-tutorial)
   in the registry. 
   3. Exclude local admin user from profile containers in local group
.EXAMPLE
   Change variables as required
   Open in powershell_ise or just run on any elevated powershell prompt
   Ensure your shell has ExecutionPolicy set sufficiently for this to run (Set-ExecutionPolicy Bypass or Unrestricted etc)
   .\Set-FSLogix-WVD.ps1
#>


# Set variables:
$vhdlocation = '\\your_storage_server\your_share'
$admin_user = Get-LocalGroupMember Administrators | Select-Object Name -Last 1

#region fslogix-install 
    Set-Location "$env:USERPROFILE\Downloads"
    Invoke-WebRequest -UseBasicParsing https://aka.ms/fslogix_download -OutFile "$env:USERPROFILE\Downloads\fslogix.zip"
    Expand-Archive "$env:USERPROFILE\Downloads\fslogix.zip"
    Remove-Item "$env:USERPROFILE\Downloads\fslogix.zip" 
    Set-Location "$env:USERPROFILE\Downloads\fslogix\x64\Release"
    Start-Process -Wait .\FSLogixAppsSetup.exe /passive 
    Remove-Item -Path "$env:USERPROFILE\Downloads\fslogix\"  -Recurse
#endregion


#region fslogix-config
    Set-Location -Path 'HKLM:\Software\FSLogix\'
    New-Item -Name 'Profiles' -Force
        # First two are required
        New-ItemProperty -Name VHDLocations -PropertyType String -Value $vhdlocation -Path 'HKLM:\Software\FSLogix\Profiles' -Force
        New-ItemProperty -Name Enabled -PropertyType DWORD -Value 1 -Path 'HKLM:\Software\FSLogix\Profiles' -Force
        # Puts username before SID to make troubleshooting easier
        New-ItemProperty -Name FlipFlopProfileDirectoryName -PropertyType DWORD -Value 1 -Path 'HKLM:\Software\FSLogix\Profiles' -Force
        # If fslogix fails, log user off
        New-ItemProperty -Name PreventLoginWithFailure -PropertyType DWORD -Value 1 -Path 'HKLM:\Software\FSLogix\Profiles' -Force
        # This deletes any locally stored profiles to prevent clashes
        New-ItemProperty -Name DeleteLocalProfileWhenVHDShouldApply -PropertyType DWORD -Value 1 -Path 'HKLM:\Software\FSLogix\Profiles' -Force
        
        # Get out of the registry
        Set-Location $env:USERPROFILE

    # Exclude local administrator for FSLogix
    Add-LocalGroupMember -Name "FSLogix Profile Exclude List" -Member $admin_user
    Get-LocalGroupMember -Name "FSLogix Profile Exclude List"
#endregion
