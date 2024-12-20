start cmd /c
"net stop wuauserv & net stop cryptSvc & net stop bits
& net stop msiserver"
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
"ping 1.1.1.1 -n 20 -w 1000 net start wuauserv & net start cryptSvc & net start bits & net start msiserver"
echo Windows Update components have been reset.
exit