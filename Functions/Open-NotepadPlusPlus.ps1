Function Open-NotepadPlusPlus
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [Alias('Path','FN')]
        [String[]]$FileName
    )
    
    Process
    {
        [String] $strProgramPath = "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe"
        IF (Test-Path -Path $strProgramPath)
        {
            & $strProgramPath $FileName
        }
        
        Else
        {
            Write-Error -Message 'It appears that you do not have Notepad++ installed on this machine'
        }
    }
}
New-Alias -Name npp -Value Open-NotepadPlusPlus -ErrorAction SilentlyContinue