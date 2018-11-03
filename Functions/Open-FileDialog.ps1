Function Open-FileDialog()
{
param (
   [string]$Title = "",
   [string]$initialDirectory="",
   [string]$filter=""
   )
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title=$title
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = $filter
    $result=$OpenFileDialog.ShowDialog()
    if ($result -eq "OK") {
        $OpenFileDialog.FileName
    }
}