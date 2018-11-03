function Get-CurrentUserOnSingleHost
{
param (
	    [parameter(Mandatory=$true, HelpMessage="Enter Old Computer Name")][string]$ComputerName

    )
#Find logged in user of remote computer
gwmi win32_computersystem -comp $ComputerName | select USername,Caption,Manufacturer

}