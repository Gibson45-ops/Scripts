#This script is useful to confirm the presence of a program or file across multiple user profiles

$usersPath = "C:\Users"
$Path = ""
Get-ChildItem -Path $usersPath -Recurse | ForEach-Object {
    $userProfilePath = "$($_.FullName)$Path"
    if (Test-Path -Path $userProfilePath) {
        Write-Output "Path exists: $userProfilePath"
    }
}

