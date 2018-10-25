# Get-OuGroupMembers
This script queries all the groups for a given Organizational Unit (OU) and then recursively pulls all of the group members for each.  The output is saved in the CSV format with two columns: the SamAccountName of the group and user objects.

## Example
```console
Get-OuGroupMembers.ps1 -OuName 'ou=groups,dc=contoso,dc=com' -OutputFile MyGroupMemberships.csv
```
### Options
`-Verbose` : use this option to see specific groups that fail to return their member objects
