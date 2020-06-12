function Set-WTBackground {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateScript({
            Test-Path $_
        })]
        [String]$Path,
        [Parameter()]
        [ValidateSet("jpg")]
        [string]$Extension
    )
    begin {
        # Determine if we are in WT
        $Profile = $env:WT_PROFILE_ID
        if (!$Profile)
        {
            throw "WT Not available"
        }

        $PathInfo = Get-Item -Path $Path
        $SettingsPath = Get-WTSettingsPath
        $SettingsJson = "$SettingsPath\Settings.json"

        # Get MD5 of File
        $FileHash = Get-FileHash -Path $Path -Algorithm SHA1 | Select -ExpandProperty Hash
        $FileHash = $FileHash[-1..-5] -join ""

        $ImageDestination = "$SettingsPath\Assets\$Profile-$FileHash.$($Extension)"
    }

    process {
        Move-Item -Path $Path -Destination $ImageDestination -Force -ErrorAction SilentlyContinue

        $Settings = Get-Content -Path $SettingsJson
        $Settings -Replace "(`"backgroundImage`": `".*\/$Profile)-(.{5})\.(.*)`"", "`$1-$($FileHash).`$3`"" | Out-File -FilePath $SettingsPath\Settings.json -Force
    }

    end {
        #Cleanup files
        Start-Sleep .5
        Get-ChildItem "$SettingsPath\Assets\$Profile*" -Exclude "$Profile-$FileHash*" | Remove-Item 
    }
}