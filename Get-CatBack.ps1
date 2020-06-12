function Get-RandomCat
{
    param(
        [Parameter()]
        [string]$Path
    )
    $local:ProgressPreference = "SilentlyContinue"
    $uri = "http://aws.random.cat/meow"
    $RestResult = Invoke-RestMethod -Uri $Uri
    Invoke-RestMethod -Uri $RestResult.File -OutFile $Path
}

