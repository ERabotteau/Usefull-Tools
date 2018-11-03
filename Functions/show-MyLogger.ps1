Function show-MyLogger {
    param(

    [Parameter(Mandatory=$true)][String]$message,
    [validateset("Green","Cyan","Yellow","red")][string]$Color="Green"
    
    )
    $timeStamp = Get-Date -Format "MM-dd-yyyy_HH-mm-ss"
    Write-Host -NoNewline -ForegroundColor White "[$timestamp]"
    Write-Host -ForegroundColor $color " $message"
}