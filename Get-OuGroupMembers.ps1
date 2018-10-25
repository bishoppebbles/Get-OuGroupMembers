<#
.SYNOPSIS
    This script queries all the groups for a given Organizational Unit (OU) and then recursively pulls all of the group members for each.  The output is saved in the CSV format.
.DESCRIPTION
    This script queries all the groups for a given Organizational Unit (OU) and then recursively pulls all of the group members for each.  The output is saved in the CSV format with two columns.  It is the SamAccountName of the group and user.
.PARAMETER SearchBase
    The OU path to search for the groups
.PARAMETER OutputFile
    The file name of the CSV output (default name: OuGroupMembers.csv)
.EXAMPLE
    Get-OuGroupMembers.ps1 -OuName 'ou=groups,dc=contoso,dc=com' -OutputFile MyGroupMemberships.csv
.NOTES
    Author: Sam Pursglove
    Version: 1.0.1
    Updated: 25 OCT 2018
#>

param (
    [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$False, HelpMessage='Enter the target OU name')]
    [String]
    $OuName,

    [Parameter(Position=1, Mandatory=$False, ValueFromPipeline=$False, HelpMessage='The output CSV file name')]
    [String]
    $OutputFile = 'OuGroupMembers.csv'
)

# array to hold the collection of custom objects
$OutputCollection = @()

# identify all groups within the given searchbase
$AllOuGroups = Get-ADGroup -Filter 'name -like "*"' -SearchBase "$SearchBase"

foreach ($group in $AllOuGroups) {
    
    try {
    
        # identify all members of a given group
        $Members = Get-ADGroupMember -Identity $group.DistinguishedName -Recursive
    
    } catch [Microsoft.ActiveDirectory.Management.ADException] {
    
        Write-Verbose "The group members of the '$($group.Name)' group cannot be accessed"
    
    } finally {}

    # create an object for each group and user SamAccountName pair
    foreach ($member in $Members) {
        $OuObject = New-Object -TypeName psobject
        $OuObject | Add-Member -MemberType NoteProperty -Name GroupSamAccountName -Value $group.SamAccountName
        $OuObject | Add-Member -MemberType NoteProperty -Name UserSamAccountName -Value $member.SamAccountName
        $OutputCollection += $OuObject
    }
}

$OutputCollection | Export-Csv -Path $OutputFile -NoTypeInformation                  