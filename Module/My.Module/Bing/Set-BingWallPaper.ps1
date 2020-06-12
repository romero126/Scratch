function Set-BingWallPaper 
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Path,

        [Parameter()]
        [ValidateRange(1,8)]
        [int]$Results = 1,

        [Parameter()]
        [ValidateSet("en-US")]
        [string]$Region = "en-US",

        [Parameter()]
        [ValidateSet('1080x1920','768x1366','240x400','480x800','768x1280','240x320','360x480','480x640','768x1024','176x220','240x240','320x320','220x176','1024x768','320x240','480x360','640x480','800x600','1920x1200','1280x768','400x240','800x480','1280x720','1366x768','1920x1080')]
        [string]$Resolution = "1920x1200"
    )

    $Path = New-TemporaryFile
    Get-BingWallPaper -Path $Path -Results $Results -Region $Region -Resolution $Resolution
    Set-WTBackground -Path $Path -Extension "jpg"
}