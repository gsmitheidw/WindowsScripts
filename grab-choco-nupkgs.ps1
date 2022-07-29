<#
. Download nupkg(s) from chocolatey community repo
#>
$downloadpath = 'c:\choco'
Set-Location $downloadpath

function get-nupkg {
param ([string]$appname)
    $source = "https://community.chocolatey.org/api/v2/package/$appname"
    $filename = [System.IO.Path]::GetFileName($source)
    $dest = "$downloadpath\$filename.nupkg"

    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($source, $dest)

    # Give it a few seconds to download
    Start-Sleep 5

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
    # rename file to include version
    Move-Item -Path $downloadpath\$filename.nupkg -Destination $downloadpath\$filename.$version.nupkg
}

$packagename = Read-Host -Prompt 'Packages to grab'                                                                   
$packagename = $packagename.Split(' ')                                                                                
foreach ($package in $packagename) {
get-nupkg $package
} 