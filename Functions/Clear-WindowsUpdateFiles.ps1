function Clear-WindowsUpdateFiles
{
    # script nettoyage fichiers temporaires de windows Update

    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {    
        Echo "This script needs to be run in Elevated Mode"
        Break
    }
    clear
    write-host "Clean-up Tool for Windows Update hang" -ForegroundColor Red
    write-host "`nthis tool will clean-up every windows Update history and files"

    $quest="Are You Sure ? [y/n]"
    $confirmation = Read-Host $quest
    while($confirmation -ne "y")
    {
        if ($confirmation -eq 'n') {break}
        $confirmation = Read-Host $quest
    }

    # start cleanup
    write-host "Removing cab files in c:\windows\temp folder" -ForegroundColor Yellow
    remove-item "C:\windows\temp\cab*" -Force

    Write-host "Stopping Windows Update Service..." -ForegroundColor Yellow
    try {
        stop-service -name wuauserv
    } catch  {
        write-host "Unable to stop Service ... Aborting" -ForegroundColor Red
        break
    }
    write-host "Rename C:\Windows\SoftwareDistribution Folder"
    try {
        Rename-Item -path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old
    } catch {
        write-host "Unable to rename folder ... Aborting" -ForegroundColor Red
        break
    }

    write-host "Starting Windows Update Service"
    Start-Service -name wuauserv
    write-host "Stopping trustedinstaller Service"
    Stop-Service -name TrustedInstaller
    write-host "wait for 2 minutes before restarting last service..."
    Start-Sleep -Seconds 120

    write-host "Removing cbs files in C:\Windows\Logs\CBS folder" -ForegroundColor Yellow
    Remove-Item C:\Windows\Logs\CBS\cbs* -Force
    Start-Service -name TrustedInstaller

    write-host "Complete..."

}