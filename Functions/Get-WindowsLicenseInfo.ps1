Function Get-WindowsLicenseInfo
{
    <#
            .Synopsis
            Get the license status of a Windows computer

            .DESCRIPTION
            Gets the license details via SLMGR.vbs /dlv

            .EXAMPLE
            Get-WindowsLicenseInfo
            Returns the license details of the local computer

            .EXAMPLE
            Get-WindowsLicenseInfo -ComputerName computer01.domain.com
            Returns the license details of the computer
    #>


    Param
    (
        [String] $ComputerName,
        
        [PSCredential] $Credential
    )
    
    Process
    {
        # Variables
        [ScriptBlock] $sbLicInfo = {
        
            ((cscript $env:windir\System32\slmgr.vbs /dlv | Select-Object -Skip 4) -replace ': ','=') | 
            ConvertFrom-StringData -ErrorAction SilentlyContinue
        }
        
        If ($ComputerName)
        {
            If ($Credential)
            {
                Invoke-Command -ScriptBlock $sbLicInfo -ComputerName $ComputerName -Credential $Credential `
                -Authentication Kerberos -ErrorAction SilentlyContinue
            }
            Else
            {
                Invoke-Command -ScriptBlock $sbLicInfo -ComputerName $ComputerName -ErrorAction SilentlyContinue
            }
        }
        Else
        {
            . $sbLicInfo
        }
    }
}