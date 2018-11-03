Function Set-NewComputerName
{
param (
	    [parameter(Mandatory=$true, HelpMessage="Enter Old Computer Name")][string]$OldName,
	    [parameter(Mandatory=$true, HelpMessage="Enter New Computer Name")][string]$NewName,
        [parameter(Mandatory=$false, HelpMessage="Reboot after competion?")][bool]$Reboot=$false
    )
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {    
        Echo "This script needs to be run in Elevated Mode"
        Break
    }


$credentials=Get-Credential
$quest="Rename $oldName to $NewName [Y/N]"
$confirmation = Read-Host $quest
while($confirmation -ne "y")
{
    if ($confirmation -eq 'n') {break}
    $confirmation = Read-Host $quest
}
Rename-Computer -ComputerName $OldName -NewName $newName -DomainCredential $credentials -Force -Restart

}