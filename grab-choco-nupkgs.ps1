
Set-Location c:\choco
Clear-Host
<#
$packagename = Read-Host -Prompt 'Packages to grab'
$packagename = $packagename.Split(' ')
foreach ($package in $packagename) {

    $fullurl =  "https://community.chocolatey.org/api/v2/package/$package" 
    Start-Process $fullurl
}
Start-Sleep 10 # give it a chance to download
Move-Item $env:USERPROFILE\Downloads\*.nupkg -Destination '\\10.10.2.8\Deploy\nupkg\' -ErrorAction Stop
#(Get-Process "msedge").CloseMainWindow() | Out-Null   #| Stop-Process
Write-Host "Done $packagename"
#>

$source = "https://community.chocolatey.org/api/v2/package/firefox"
$Filename = [System.IO.Path]::GetFileName($source)
$dest = "C:\choco\$Filename.nupkg"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($source, $dest)

Add-Type -assembly "system.io.compression.filesystem"
$zip = [io.compression.zipfile]::OpenRead("$dest")
$file = $zip.Entries | where-object { $_.Name -eq "$filename.nuspec"}
$stream = $file.Open()

$reader = New-Object IO.StreamReader($stream)
$text = $reader.ReadToEnd()

$reader.Close()
$stream.Close()
$zip.Dispose()

#cast to xml
[xml]$xml = $text

$version = $xml.SelectNodes('/*/*') | Select-Object -ExpandProperty version
Move-Item -Path c:\Choco\$Filename.nupkg -Destination c:\choco\$Filename.$version.nupkg