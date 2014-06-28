[CmdletBinding()]
Param(
	[Parameter(ParameterSetName = "File", Mandatory = $true)][Switch][Alias('f')]$file,
    [Parameter(ParameterSetName = "File", Mandatory = $true)][System.IO.FileInfo]$name,
    [Parameter(ParameterSetName = "Directory", Mandatory=$true)][Switch][Alias('d')]$directory,
    [Parameter(ParameterSetName = "Directory", Mandatory = $true)][System.IO.FileInfo]$path
)

function Main () {
    $script_directory = Split-Path -parent $PSCommandPath   
	$base_dir  = resolve-path $script_directory
    $tag_lib = "$base_dir\taglib-sharp.dll"
    [system.reflection.assembly]::loadfile($tag_lib)

    if ($file){
        # Write-host "rename single file $name"
        $info = extract-tag-info $name
        Write-Host $info
        calculate-file-name $name
    }
    if ($directory){
        Write-host "rename all files from directory $path"
    }
}

function extract-tag-info([System.IO.FileInfo]$f){
    $mp3 = [TagLib.File]::create($f.FullName);
    $contributingInfo = @{
        Artist = $mp3.Tag.FirstArtist
        Title = $mp3.Tag.Title
        TrackNumber = $mp3.Tag.Track
    }
    return New-Object psobject -Property $contributingInfo
}

function calculate-file-name($info, $includeSong)
{
    
}

Main