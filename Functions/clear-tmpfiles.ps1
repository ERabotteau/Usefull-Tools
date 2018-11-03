function Clear-TmpFiles
{
    remove-item "C:\temp\*" -Recurse -Force
    remove-item "C:\windows\Temp\*" -Recurse -Force
}
