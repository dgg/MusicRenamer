[CmdletBinding()]
Param(
	[Parameter(ParameterSetName = "File", Mandatory = $true)][Switch][Alias('f')]$file,
    [Parameter(ParameterSetName = "File", Mandatory = $true)][System.IO.FileInfo]$name,
    [Parameter(ParameterSetName = "Directory", Mandatory=$true)][Switch][Alias('d')]$directory,
    [Parameter(ParameterSetName = "Directory", Mandatory = $true)][System.IO.FileInfo]$path,
    [Switch][Alias('n')]$includeTrackNumber
)

function Main () {
    $script_directory = Split-Path -parent $PSCommandPath   
	$base_dir  = resolve-path $script_directory
    $tag_lib = "$base_dir\taglib-sharp.dll"
    [system.reflection.assembly]::loadfile($tag_lib) | Out-Null

    if ($file -and $name.Exists){
        rename-file $name $includeTrackNumber
    }
    if ($directory -and $path.Exists){
        Write-host "rename all files from directory $path"
    }
}

function rename-file([System.IO.FileInfo]$f, $track)
{
    $info = extract-tag-info $f
    $file_name = calculate-file-name $info $track
    # have to use indexer despite returning a string :-O
    $file_name = Join-Path $f.DirectoryName $file_name[0]
    $f.MoveTo($file_name)
}

function extract-tag-info([System.IO.FileInfo]$f){
    $mp3 = [TagLib.File]::create($f.FullName);
    $contributingInfo = @{
        Artist = $mp3.Tag.FirstComposer
        Title = $mp3.Tag.Title
        TrackNumber = $mp3.Tag.Track
    }
    return New-Object psobject -Property $contributingInfo
}

function calculate-file-name($info, $track)
{
    [System.Text.StringBuilder] $sb = New-Object System.Text.StringBuilder
    $sb.Append($info.Artist);
    $sb.Append('-');
    $sb.Append($info.Title);
    $sb.Append('.mp3');

    title-ize($sb)
        
    if ($track){
        $sb.Insert(0, $info.TrackNumber.ToString("00\."));
    }
    return $sb.ToString()
}

function title-ize([System.Text.StringBuilder]$sb)
{
    [int]$length = $sb.Length;
    $sb[0] = [char]::ToUpperInvariant($sb[0]);
    [bool]$capitalizeNext = $false;

    for ($i = 1; $i -lt $length; $i++)
    {
        if ($sb[$i] -eq ' ')
        {
		    $capitalizeNext = true;
		    $sb.Remove($i, 1);
		    $length--;
		    $i--;
		}
	    else
	    {
		    if ($capitalizeNext)
		    {
			    $sb[$i] = [char]::ToUpperInvariant($sb[$i]);
			    $capitalizeNext = false;
		    }
        }
    }
}

Main