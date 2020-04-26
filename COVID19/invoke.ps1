function Get-Covid19
{
    param(
        [parameter()]
        [string[]]$Path,
        [parameter()]
        [string]$Property,
        [parameter()]
        [string]$showval
    )
    
    $token = Get-CovidBingToken

    $Header = @{
        "authorization" = $token.AuthToken
    }

    $data = Invoke-RestMethod "https://bing.com/covid/data?ig=$($token.IG)" -Header $Header
    if ($path) {
        foreach ($path in $path.split("\"))
        {
            $data = @($data).Where({ $_.displayName -match $path }).areas
        }    
    }
    $data = $data | Select pos,* -ExcludeProperty areas, id, lat, long

    # Allow sort by Property
    if ($Property)
    {
        $data = $data | sort-object $property -Descending
    }

    # Rank by position
    $n = 1; $data | ForEach-Object { $_.pos = $n++ }

    #Poll Data
    if ($showval)
    { 
        $data | ft -a | out-string | select-string ".*$showval.*" -AllMatches
        return
    }
    $data
}



function Get-CovidBingToken {

    $Body = Invoke-RestMethod -uri "https://bing.com/covid/config.ts"

    $result = @{
        Token       = [regex]::Match($Body, "token='([\w\W]*?)'").Groups[1].Value
        IG          = [regex]::Match($Body, 'ig="([\w\W]*?)"').Groups[1].Value
        AuthToken   = ""
    }
    $result.AuthToken = "Basic {0}" -f [System.Convert]::ToBase64String($result.Token.ToCharArray())
    $result 
}

function Get-Covid19TestLocations {
    param(
        [string]$area
    )

    $token = Get-CovidBingToken
    $Header = @{
        "authorization" = $token.AuthToken
    }
    try {

        $data = Invoke-RestMethod -Uri "https://bing.com/covid/testinglocations?ig=$($token.IG)" -Headers $Header
    }
    catch {
        throw $_
    }

    $Query = $data.PSObject.Properties.Name -like "$($area)_unitedstates"

    if ($Query.Count -gt 1)
    {
        Write-Host ""
        Write-Warning "You need to narrow down your search"
        Write-Host ""
        $Query.ForEach({ "'$_'" }) -join ", " | Write-Host -ForeGroundColor Cyan
        return
    }
    
    $item = $data.$Query

    #[PSCustomObject]@{
    #    Protocol            = $item.BasicInfo.Protocol
    #    Hotline             = $item.BasicInfo.HotLine
    #    Hours               = $item.BasicInfo.MetaData[0]
    #    PartnerCompanies    = $item.BasicInfo.PartnerCompanies
    #} | fl
    Write-Host ""
    Write-Host $item.BasicInfo.Protocol -ForegroundColor Yellow
    Write-Host ""
    Write-Host " Hotline: $($item.BasicInfo.HotLine)"
    Write-Host "   Hours: $($item.BasicInfo.MetaData[0])"
    Write-Host ""
    Write-Host ""

    $Result = 
    foreach ($i in $item.TestingLocations)
    {
        [PSCustomObject]@{
            ApptType               = ($i.ApptType -Split "Appointment Needed: ")[1]
            Name                   = $i.Name
            Address                = $i.Address
            OfficialSiteUrl        = $i.OfficialSiteUrl
            AddressLink            = $i.AddressLink
            MobileClickThroughLink = $i.MobileClickThroughLink
            MapsClickThroughLink   = $i.MapsClickThroughLink
            EntityId               = $i.EntityId
            Geo                    = $i.Geo
            PrimaryCategoryId      = $i.PrimaryCategoryId
            PhoneNumber            = $i.MetaData[0]
            OpenHours              = $i.MetaData[1]
            AppointmentType        = $i.MetaData[2]
            PartnerCompanies       = $i.PartnerCompanies
        }
    }
    $Result
}

#Get-Covid19TestLocations -Area "Hawaii"
#Get-Covid19 -path 'Global\United States\Washington' -showval "King County"