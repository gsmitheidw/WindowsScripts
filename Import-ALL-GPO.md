## Info and explaination relating to Import-ALL-GPO.ps1

I spent quite some time trying to bulk import Group Polices. The methods that you read on most forums and documentation only work if you know the policy name 
(I just have a zip of GUIDs of policy objects with xml files beneath - not very readable!) and are prepared to do these imports one at a time. I had hundreds!

The old ImportAllGPOs.wsf script from MS is no longer available pre-installed with Group Policy Management Console on current (2019+) Windows Server Builds 
- the MS Documentation relating to it points to it being available to download from the Script Gallery but it is no longer available there either. 
I have managed to get around this using an existing powershell script (see in comments of my script linked below) to pull names of policies from the backed up 
folder buried deep in the XML code. 

To that, I have written a simple loop that will loop through those names and import each one at a time by name. 

https://github.com/gsmitheidw/WindowsScripts/blob/main/Import-ALL-GPO.ps1

Other points to note which many may not be aware - 
- Do not look at creating by ID because you will still need the name anyway in order to create a new target policy. Hope this proves useful to others. 
- Group Policy Backups only back up the policy objects, they do not maintain any links to organisational units. Unfortunately that has to be recreated manually.
  This is a limitation in the (somewhat archaic) GPO technology. 
- If you are putting policies back into the same domain in the same forest, Restore-GPO is worth looking at. But if you're migrating policies to a different domain/forest - you need to use Import. 
- The FQDN for objects named in policies in a new domain compared to old domain may differ and you may need a migration table (in Group Policy Management Console) to map the users to their new domain equivalent.

Hope this is useful for others - this should be far more intuitive and better documented by MS. 

