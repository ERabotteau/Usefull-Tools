<#
.LINK
	https://www.osdeploy.com
.SYNOPSIS
	Creates a Bootable FAT32 USB (32GB or smaller) and copies a Mounted ISO.
.DESCRIPTION
	Creates a Bootable FAT32 USB (32GB or smaller) and copies a Mounted ISO.
.PARAMETER ISOFile
	Full path to the ISO file to Mount
.PARAMETER MakeBootable
	Uses Bootsect to make the USB Bootable
.PARAMETER USBDriveLabel
	USB Drive Label (no spaces)
.EXAMPLE
	Copy-IsoToUsb -ISOFile "C:\Temp\SW_DVD5_Win_Pro_Ent_Edu_N_10_1709_64BIT_English_MLF_X21-50143.ISO" -MakeBootable -USBDriveLabel WIN10X64
	You will be prompted to select a USB Drive in GridView
.NOTES
    NAME:	Copy-IsoToUsb.ps1
	AUTHOR:	David Segura, david@segura.org
	BLOG:	http://www.osdeploy.com
	VERSION:	18.9.4
			
	Original credit to Mike Robbins
	http://mikefrobbins.com/2018/01/18/use-powershell-to-create-a-bootable-usb-drive-from-a-windows-10-or-windows-server-2016-iso/
	
	Additional credit to Sergey Tkachenko
	https://winaero.com/blog/powershell-windows-10-bootable-usb/
#>

function Copy-IsoToUsb {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq '.iso')})]
        [string]$ISOFile,
		[switch]$MakeBootable,
		[switch]$NTFS,
        [string]$USBLabel
    )
	BEGIN {
		#======================================================================================
		Write-Verbose "Validating Elevated Permissions ..."
		#======================================================================================
		$Elevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
		if ( -not $Elevated ) {
			Throw "This Function requires Elevation"
		}
	}
	
	PROCESS {
		#======================================================================================
		Write-Verbose "Selecting USB Drive ..."
		#======================================================================================
		if ($NTFS) {
			$Results = Get-Disk | Where-Object {$_.Size/1GB -lt 33 -and $_.BusType -eq 'USB'} | Out-GridView -Title 'Select USB Drive to Format' -OutputMode Single | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -PassThru | New-Partition -UseMaximumSize -IsActive -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel $USBLabel
		} else {
			$Results = Get-Disk | Where-Object {$_.Size/1GB -lt 33 -and $_.BusType -eq 'USB'} | Out-GridView -Title 'Select USB Drive to Format' -OutputMode Single | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -PassThru | New-Partition -UseMaximumSize -IsActive -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel $USBLabel
		}
		
		#======================================================================================
		Write-Verbose "Validating a USB Drive was Selected ..."
		#======================================================================================
		if($null -eq $Results) {
			Throw "No USB Driver was Found or Selected"
		}

		#======================================================================================
		Write-Verbose "Getting Volumes ..."
		#======================================================================================
		$Volumes = (Get-Volume).Where({$_.DriveLetter}).DriveLetter
		
		#======================================================================================
		Write-Verbose "Mounting the ISO ..."
		#======================================================================================
		Mount-DiskImage -ImagePath $ISOFile
		
		#======================================================================================
		Write-Verbose "Waiting 5 Seconds ..."
		#======================================================================================
		Start-Sleep -s 5
		
		#======================================================================================
		Write-Verbose "Detemrining the Drive Letter of the Mounted ISO ..."
		#======================================================================================
		$ISO = (Compare-Object -ReferenceObject $Volumes -DifferenceObject (Get-Volume).Where({$_.DriveLetter}).DriveLetter).InputObject
		
		#======================================================================================
		Write-Verbose "Making the USB Drive Botoable ..."
		#======================================================================================
		if ($MakeBootable.IsPresent) {
			Set-Location -Path "$($ISO):\boot"
			bootsect.exe /nt60 "$($Results.DriveLetter):"	
		}
		
		#======================================================================================
		Write-Verbose "Copying Files ..."
		#======================================================================================
		Copy-Item -Path "$($ISO):\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose

		#======================================================================================
		Write-Verbose "Dismounting Disk Image ..."
		#======================================================================================
		Dismount-DiskImage -ImagePath $ISOFile
	}
	END {
		#======================================================================================
		Write-Verbose "Complete"
		#======================================================================================
	}
}