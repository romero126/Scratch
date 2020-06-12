function Set-BingSearchImage 
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$Query
    )

    $Path = New-TemporaryFile
    Get-BingSearchImage -Path $Path -Query $Query
    Set-WTBackground -Path $Path -Extension "jpg"
}