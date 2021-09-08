<#  Requires the function Get-GPOBackup https://jdhitsolutions.com/blog/powershell/1460/get-gpo-backup/
.  Use Get-GPOBackup function like this to get the policy names
.  Get-GPOBackup -Path C:\path-to\policies | select Name | out-file C:\BackupNames.txt
.  
.#>

# Path to backed up policies (unzipped)
$bPath = 'C:\GroupPolicyBackup\'
$names = Get-Content C:\BackupNames.txt

# You may need a migration table if importing to a different domain/forest and there are are equivalent items to be mapped to from the old polcies:

foreach ($name in $names) {

Import-GPO -BackupGpoName $name -Path $bPath -MigrationTable C:\migration.migtable -TargetName $name -CreateIfNeeded

}
