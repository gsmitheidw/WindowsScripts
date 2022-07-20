<#
. Download multiple chocolatey nupkgs from community repo for local hosting.
. --------------------------------------------------------------------------
. This will prompt for a list of chocolatey packages which should be entered space delimited
. These will be downloaded by default web browser to default save path.
. Unfortunately this will not download dependency packages (eg: 7zip depends on 7zip.install etc).
. These have to specified manually. 
#>
$packagenames = Read-Host -Prompt 'List of Packages to grab'
$packagenames = $packagenames.Split(' ')
foreach ($package in $packagenames) {

	    $fullurl =  "https://community.chocolatey.org/api/v2/package/$package" 
	        Start-Process $fullurl

}
