# Get-Covid


# Invoke from the Interwebs
``` powershell
irm "https://raw.githubusercontent.com/romero126/Scratch/master/COVID19/invoke.ps1" | iex
```

# Available Commands
## Statistics
``` PowerShell
Example:
Get-Covid19 "Global\United States"


NAME
    Get-Covid19

SYNTAX
    Get-Covid19 [[-Path] <string[]>] [[-Property] <string>] [[-showval] <string>] [<CommonParameters>]

ALIASES
    None


REMARKS
    None
```

## Test Locations

``` powershell
Get-Covid19TestLocations -area "Washington"

NAME
    Get-Covid19TestLocations

SYNTAX
    Get-Covid19TestLocations [[-area] <string>]


ALIASES
    None


REMARKS
    None

```