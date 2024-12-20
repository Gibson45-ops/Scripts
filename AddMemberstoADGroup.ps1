Import-Module ActiveDirectory
#Define the name of your AD group Place in Quotes ""#
$groupname =
#Define Your members you want to add (Users & Groups) Ensure they are seperated by a comma#
$Members =
Add-ADGroupMember -Identity $groupname -Members $Members
