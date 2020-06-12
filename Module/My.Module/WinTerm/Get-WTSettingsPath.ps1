function Get-WTSettingsPath {
    # Determine if we are in WT
    $Profile = $env:WT_PROFILE_ID
    if (!$Profile)
    {
        throw "WT Not available"
    }

    $SettingsPath = Get-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal*\LocalState\" | Select-Object -ExpandProperty FullName
    $SettingsPath
}