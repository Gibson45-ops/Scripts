# Import the Active Directory module to access AD cmdlets
Import-Module ActiveDirectory

# Define the file path for the file you want to modify permissions for
$TransferFilePath = ""

# Define the identity (user or group) to whom you want to grant access
$identity = ""

# Define the file owner you want to set for the file
$FileOwner = ""

# Retrieve the current access control list (ACL) of the file
$NewAcl = Get-Acl -Path $TransferFilePath

# Define the type of permissions to grant (in this case, 'Modify' rights)
$fileSystemRights = [System.Security.AccessControl.FileSystemRights]::Modify

# Set inheritance flags so permissions apply to both the folder and its contents
$inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit, [System.Security.AccessControl.InheritanceFlags]::ObjectInherit

# Specify no  propagation
$propagationFlags = [System.Security.AccessControl.PropagationFlags]::None

# Specify that the permission being added is of type 'Allow'
$type = [System.Security.AccessControl.AccessControlType]::Allow

# Add Permissions to a file/folder using the provided arguments
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $inheritanceFlags, $propagationFlags, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList

# Add the new access rule to the File 
$NewAcl.AddAccessRule($fileSystemAccessRule)

# Apply the updated ACL object to the file
Set-Acl -Path $TransferFilePath -AclObject $NewAcl
