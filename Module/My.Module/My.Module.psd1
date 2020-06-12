Write-Verbose "Loading My.Module"

$Scripts = Get-ChildItem -Path $PSScriptRoot -Include "*.ps1" -Recurse
$PublicScripts = @()

foreach ($Script in $Scripts)
{
    try {
        Write-Verbose "Loading File '$($Script.BaseName)'"

        if ($Script.BaseName.EndsWith(".Public")) {
            $PublicScripts += $Script.BaseName.SubString(0, $Script.BaseName.Length-".Public".Length)
        }
        . $Script
    }
    catch {
        Write-Warning "Failed to load script '$($Script.BaseName)'"
        throw $_
    }

}