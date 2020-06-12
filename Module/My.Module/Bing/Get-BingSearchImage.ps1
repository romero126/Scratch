function Get-BingSearchImage {
    param(
        [Parameter()]
        [String]$Query = "Powershell Wallpaper",
        [Parameter(Mandatory)]
        [string]$Path
    )
    $Query = $Query.Replace(" ", "+")
    $local:ProgressPreference = "SilentlyContinue"
    $uri = "https://www.bing.com/search?q=$Query"

    $RestResult = Invoke-RestMethod -Uri $Uri

    $Result = ([regex]::Matches($RestResult, "src=`"(.*?)`"") | ? Value -match "OIP" | Get-Random).Groups[1].Value
    Invoke-RestMethod -Uri $Result -OutFile $Path
}