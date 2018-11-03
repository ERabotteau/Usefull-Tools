function Save-FileDialog( ) 
{
param (
   [string]$Title = "",
   [string]$initialDirectory="",
   [string]$filter=""
   )
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $OpenFileDialog.Title=$title
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = $filter
    $OpenFileDialog.ShowDialog() |  Out-Null
 
    return $OpenFileDialog.filename
} 