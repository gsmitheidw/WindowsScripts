# Lesser Known Windows Commands

Some of these are archaic or legacy, some still have modern and interesting uses.
Many of these are superceded by powershell cmdlets. But not all. These are only
ones that may be lesser known and possibly not on ss64.com etc. 

* xwizard
Process XML  (Vista era)

* cipher
Encrypt files/folders

* pushd/popd
Put paths into a stack

* pnputil
List/export device drivers

* qwinsta
Like quser

* query
query session 

* tzutil
locale

* wecutil
Windows Event collection

* auditpol
config audit file policy

* change
Change Terminal Service settings

* fciv
Like and older Get-FileHash for checksums

* msg
Like the old net send

* snippingtool
can be invoked via command

* cttune
Enable cleartype fonts

* findstr
Like grep

* bitsadmin
File transfer as background task

<details>
<summary>* psr </summary>

```cmd
psr.exe [/start |/stop][/output ] [/sc (0|1)] [/maxsc ]
    [/sketch (0|1)] [/slides (0|1)] [/gui (o|1)]
    [/arcetl (0|1)] [/arcxml (0|1)] [/arcmht (0|1)]
    [/stopevent ] [/maxlogsize ] [/recordpid ]

/start         :Start Recording. (Outputpath flag SHOULD be specified)
/stop          :Stop Recording.
/sc            :Capture screenshots for recorded steps.
/maxsc         :Maximum number of recent screen captures.
/maxlogsize    :Maximum log file size (in MB) before wrapping occurs.
/gui           :Display control GUI.
/arcetl        :Include raw ETW file in archive output.
/arcxml        :Include MHT file in archive output.
/recordpid     :Record all actions associated with given PID.
/sketch        :Sketch UI if no screenshot was saved.
/slides        :Create slide show HTML pages.
/output        :Store output of record session in given path.
/stopevent     :Event to signal after output files are generated.

PSR Usage Examples:

psr.exe
psr.exe /start /output fullfilepath.zip /sc1 /gui 0 /record 
    /stopevent  /arcetl 1

psr.exe /start /output fullfilepath.xml /gui 0 /recordpid 
    /stopevent 

psr.exe /start /output fullfilepath.xml /gui 0 /sc 1 /maxsc 
    /maxlogsize  /stopevent 

psr.exe /stop

Notes:
1.    Output path should include a directory path (e.g. '.\file.xml').
2.    Output file can either be a ZIP file or XML file
3.    Can't specify /arcxml /arcetl /arcmht /sc etc. if output is not a ZIP file.

```
</details>
Problem Steps Recorder
