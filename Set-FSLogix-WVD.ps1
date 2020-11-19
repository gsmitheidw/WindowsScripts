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


#region fslogix-config-registry
    $regpath = 'HKLM:\Software\FSLogix\Profiles'
    Set-Location -Path $regpath
    New-Item -Name 'Profiles' -Force
        # First two are required:
        New-ItemProperty -Name VHDLocations -PropertyType String -Value $vhdlocation -Path $regpath -Force
        New-ItemProperty -Name Enabled -PropertyType DWORD -Value 1 -Path $regpath -Force
        # Puts username before SID to make troubleshooting easier:
        New-ItemProperty -Name FlipFlopProfileDirectoryName -PropertyType DWORD -Value 1 -Path $regpath -Force
        # If fslogix fails (to create vhd specified in the VHDLocations), log the user off
        New-ItemProperty -Name PreventLoginWithFailure -PropertyType DWORD -Value 1 -Path $regpath -Force
        # This deletes any locally stored profiles to prevent clashes
        New-ItemProperty -Name DeleteLocalProfileWhenVHDShouldApply -PropertyType DWORD -Value 1 -Path $regpath -Force
        # Undocumented key from FSLogix to fix an issue with RSOP failing
        # Source: https://james-rankin.com/videos/user-group-policies-not-applying-when-using-fslogix-profile-containers
        New-ItemProperty -Name GroupPolicyState -PropertyType DWORD -Value 0 -Path $regpath -Force
        
        # Get out of the registry
        Set-Location $env:USERPROFILE

    # Exclude local administrator for FSLogix
    Add-LocalGroupMember -Name "FSLogix Profile Exclude List" -Member $admin_user
    Get-LocalGroupMember -Name "FSLogix Profile Exclude List"
#endregion
