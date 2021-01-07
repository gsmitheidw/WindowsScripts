<#
Function to test for existence of a chocolatey package on a system.
#>
function Test-ChocoApp($appname) {
    
        $chocoapp = (clist -lo | Out-String).Split([Environment]::NewLine) | Select-String $appname
        if ($chocoapp -eq $null) {
            write-host -ForegroundColor DarkYellow "$appname not installed on $env:COMPUTERNAME"
            #cinst nss-client -s \\comphome.computing.stu.it-tallaght.ie\deploy\nupkg -y
        }
        else
        {
            Write-Host -ForegroundColor Green "$appname is installed on $env:COMPUTERNAME"
        }
}

$appname = 'nss-client 14.0'

Test-ChocoApp($appname)
