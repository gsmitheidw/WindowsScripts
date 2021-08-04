<#
. Create Self Signed Cert and export for portability and import to trusted root certificate store
.
#>
$pwd = ConvertTo-SecureString -String (Read-Host -Prompt 'Enter Password' ) -Force -AsPlainText
$domain = Read-Host -Prompt 'Enter Domain (eg: contoso.com)'
$certpath = 'cert:\LocalMachine\My'

$CertDetails = @{

    Type = 'Custom'
    Subject = $domain
    KeyUsage = 'DigitalSignature'
    KeyAlgorithm = 'RSA'
    KeyLength = 2048
    CertStoreLocation = $certpath
    NotAfter = (Get-Date).AddYears(5)
    Confirm = $true
}
New-SelfSignedCertificate @CertDetails 

$cert = Get-ChildItem -Path $certpath | where Subject -eq $domain 

Export-PfxCertificate -FilePath $env:USERPROFILE\Desktop\msix-$domain.pfx -Password $pwd -Cert $cert -Confirm:$true 

Import-PfxCertificate -FilePath $env:USERPROFILE\Desktop\msix-$domain.pfx -Password $pwd -CertStoreLocation Cert:\LocalMachine\Root -Confirm:$true 
