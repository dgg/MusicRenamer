[CmdletBinding()]
Param(
	[Parameter(ParameterSetName = "File", Mandatory = $true)][Switch][Alias('f')]$file,
    [Parameter(ParameterSetName = "File", Mandatory = $true)][System.IO.FileInfo]$name,
    [Parameter(ParameterSetName = "Directory", Mandatory=$true)][Switch][Alias('d')]$directory,
    [Parameter(ParameterSetName = "Directory", Mandatory = $true)][System.IO.FileInfo]$path
)

function Main () {
    if ($file){
        Write-host "rename single file $name"
    }
    if ($directory){
        Write-host "rename all files from directory $path"
    }
}
Main