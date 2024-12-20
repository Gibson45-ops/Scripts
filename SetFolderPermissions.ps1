
$transferpath = "T:\Accounting"
$identity = "scriptcare\transfer-accounting-r" 

$NewAcl = Get-Acl $transferpath

$fileSystemRights = [System.Security.AccessControl.FileSystemRights]::Read -bor [System.Security.AccessControl.FileSystemRights]::ListDirectory
$inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit, [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
$type = [System.Security.AccessControl.AccessControlType]::Allow

$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $inheritanceFlags, $propagationFlags, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList

#VeryImportant that it is AddAccessRule and not SetAccessRule as Set will overwrite existing permission on the target folder#
$NewAcl.AddAccessRule($fileSystemAccessRule)

Set-Acl $transferpath -AclObject $NewAcl
