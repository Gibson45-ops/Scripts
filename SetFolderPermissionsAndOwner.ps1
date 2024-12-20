Import-Module ActiveDirectory

$TransferFilePath = "\\scitransfer\transfer\"
$identity = "scriptcare\"
$FileOwner = "scriptcare\"

$NewAcl = Get-Acl -Path $TransferFilePath

$fileSystemRights = [System.Security.AccessControl.FileSystemRights]::Modify
$inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit, [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
$type = [System.Security.AccessControl.AccessControlType]::Allow

$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $inheritanceFlags, $propagationFlags, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList

$NewAcl.AddAccessRule($fileSystemAccessRule)

Set-Acl -Path $TransferFilePath -AclObject $NewAcl

$newOwner = New-Object System.Security.Principal.NTAccount("$FileOwner") 

$NewAcl.SetOwner($newOwner)

Set-Acl -Path $TransferFilePath -AclObject $NewAcl
