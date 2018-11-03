function Enable-WINRM
{
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {    
        Echo "This script needs to be run in Elevated Mode"
        Break
    }

    Set-Service WinRM -StartupType Automatic
    Set-Service winrm -Status Running
    Enable-PSRemoting -Force
}
