<#
Function to test for existence of a chocolatey package on a system.
#>
function Test-ChocoApp($appname) {
    
        $chocoapp = (choco list | Out-String).Split([Environment]::NewLine) | Select-String $appname
        if ($chocoapp -eq $null) {
            write-host -ForegroundColor DarkYellow "$appname not installed on $env:COMPUTERNAME"
            #cinst nss-client -s \\\path\to\nupkg -y
        }
        else
        {
            Write-Host -ForegroundColor Green "$appname is installed on $env:COMPUTERNAME"
        }
}

$app = 'nss-client 14.0'

Test-ChocoApp($app)


<# 
# Export list of chocolatey installed software to a csv file in a nice one-liner. Export-CSV is longwinded.
# The character encoding is important, powershell defaults to utf16 but we need utf8 to
# ensure the name and version render to adjacent spreadsheet cells rather than all in one cell per line. 
#>
(choco list).Replace(" ",',') | Out-File -Encoding utf8 .\software.csv
