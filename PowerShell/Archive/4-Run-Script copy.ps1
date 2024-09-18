# $scriptPath = "C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1"
# Invoke-Expression "& '$scriptPath'"


# $scriptPath = "C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1"
# Invoke-Command -FilePath $scriptPath


# Example of a PowerShell script calling another script

# Define the path to the script
# $scriptPath = "C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1"




# function Validate-FilePath {
# <#
# .SYNOPSIS
#     Validates a file path to ensure it meets expected criteria for either Windows or Linux systems.

# .DESCRIPTION
#     This function validates whether a given file path is correctly formatted and, for Windows paths, whether it exists.
#     It supports both Windows and Linux path formats and throws an error if the path is invalid.

# .PARAMETER Path
#     The file path to be validated.

# .PARAMETER PathType
#     The type of the path to be validated. Must be either "Windows" or "Linux". Default is "Windows".

# .EXAMPLE
#     PS> Validate-FilePath -Path 'C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1' -PathType 'Windows'
#     Validates the Windows file path.

# .EXAMPLE
#     PS> Validate-FilePath -Path '/usr/src/CB/Entra/ARH/Get-EntraConnectSyncErrorsfromEntra copy.ps1' -PathType 'Linux'
#     Validates the Linux file path.
# #>

#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$Path,

#         [ValidateSet("Windows", "Linux")]
#         [string]$PathType = "Windows"
#     )

#     Begin {
#         Write-Host "Starting path validation..."
#     }

#     Process {
#         try {
#             Write-Host "Validating $PathType path: $Path"

#             if ($PathType -eq "Windows") {
#                 if (-not [System.IO.Path]::IsPathRooted($Path)) {
#                     throw "The Windows path is not a valid rooted path: $Path"
#                 }
#                 if (-not (Test-Path $Path)) {
#                     throw "The Windows path does not exist: $Path"
#                 }
#             }
#             elseif ($PathType -eq "Linux") {
#                 if (-not $Path.StartsWith("/")) {
#                     throw "The Linux path is not valid, it must start with '/': $Path"
#                 }
#             }

#             Write-Host "$PathType path is valid: $Path"
#         }
#         catch {
#             Write-Host "Error during validation: $_"
#             throw
#         }
#     }

#     End {
#         Write-Host "Path validation completed."
#     }
# }

# # # Example usage:
# # $winPath = 'C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1'
# # Validate-FilePath -Path $winPath -PathType 'Windows'



# <#
# .SYNOPSIS
#     Converts a Windows file path to a Linux file path and validates both before and after conversion.

# .DESCRIPTION
#     This function takes a Windows file path as input, validates it, converts it to a Linux file path,
#     and then validates the converted Linux path. It assumes a mapping from a base Windows path to a base Linux path.

# .PARAMETER WindowsPath
#     The full file path in Windows format that needs to be converted.

# .PARAMETER WindowsBasePath
#     The base directory path in Windows from which the relative path begins. Default is 'C:\Code'.

# .PARAMETER LinuxBasePath
#     The base directory path in Linux where the Windows base path is mapped. Default is '/usr/src'.
# #>
# function Convert-And-Validate-Path {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$WindowsPath,

#         [string]$WindowsBasePath = 'C:\Code',

#         [string]$LinuxBasePath = '/usr/src'
#     )

#     Begin {
#         Write-Host "Starting the path conversion process..."
#         Validate-FilePath -Path $WindowsPath -PathType "Windows"
#     }

#     Process {
#         try {
#             if (-not $WindowsPath.StartsWith($WindowsBasePath, [System.StringComparison]::OrdinalIgnoreCase)) {
#                 throw "The provided Windows path does not start with the expected base path: $WindowsBasePath"
#             }

#             Write-Host "Input Windows Path: $WindowsPath"
#             Write-Host "Converting to relative path..."

#             $relativePath = $WindowsPath.Substring($WindowsBasePath.Length).Replace('\', '/')
#             $linuxPath = $LinuxBasePath + $relativePath

#             Write-Host "Converted Linux Path: $linuxPath"
#             Validate-FilePath -Path $linuxPath -PathType "Linux"

#             return $linuxPath
#         }
#         catch {
#             Write-Host "Error during conversion: $_"
#             throw
#         }
#     }

#     End {
#         Write-Host "Path conversion completed."
#     }
# }

# # Example usage:
# $winPath = "C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1"
# $linuxPath = Convert-And-Validate-Path -WindowsPath $winPath
# Write-Host "Linux path: $linuxPath"






# function Convert-And-Validate-Path {

    
# <#
# .SYNOPSIS
#     Converts a Windows file path to a Linux file path and validates both before and after conversion.

# .DESCRIPTION
#     This function takes a Windows file path as input, validates it, converts it to a Linux file path,
#     and then validates the converted Linux path. It assumes a mapping from a base Windows path to a base Linux path.

# .PARAMETER WindowsPath
#     The full file path in Windows format that needs to be converted.

# .PARAMETER WindowsBasePath
#     The base directory path in Windows from which the relative path begins. Default is 'C:\Code'.

# .PARAMETER LinuxBasePath
#     The base directory path in Linux where the Windows base path is mapped. Default is '/usr/src'.
# #>
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$WindowsPath,

#         [string]$WindowsBasePath = 'C:\Code',

#         [string]$LinuxBasePath = '/usr/src'
#     )

#     Begin {
#         Write-Host "Starting the path conversion process..."
#         Validate-FilePath -Path $WindowsPath -PathType "Windows"
#     }

#     Process {
#         try {
#             if (-not $WindowsPath.StartsWith($WindowsBasePath, [System.StringComparison]::OrdinalIgnoreCase)) {
#                 throw "The provided Windows path does not start with the expected base path: $WindowsBasePath"
#             }

#             Write-Host "Input Windows Path: $WindowsPath"
#             Write-Host "Converting to relative path..."

#             $relativePath = $WindowsPath.Substring($WindowsBasePath.Length).Replace('\', '/')
#             $linuxPath = $LinuxBasePath + $relativePath

#             Write-Host "Converted Linux Path: $linuxPath"
#             Validate-FilePath -Path $linuxPath -PathType "Linux"

#             return $linuxPath
#         } catch {
#             Write-Host "Error during conversion: $_"
#             throw
#         }
#     }

#     End {
#         Write-Host "Path conversion completed."
#     }
# }


# function Validate-FilePath {
#     <#
# .SYNOPSIS
#     Validates a file path to ensure it meets expected criteria for either Windows or Linux systems.

# .DESCRIPTION
#     This function validates whether a given file path is correctly formatted and, for Windows paths, whether it exists.
#     It supports both Windows and Linux path formats and throws an error if the path is invalid.

# .PARAMETER Path
#     The file path to be validated.

# .PARAMETER PathType
#     The type of the path to be validated. Must be either "Windows" or "Linux". Default is "Windows".

# .EXAMPLE
#     PS> Validate-FilePath -Path 'C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1' -PathType 'Windows'
#     Validates the Windows file path.

# .EXAMPLE
#     PS> Validate-FilePath -Path '/usr/src/CB/Entra/ARH/Get-EntraConnectSyncErrorsfromEntra copy.ps1' -PathType 'Linux'
#     Validates the Linux file path.
# #>
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$Path,

#         [ValidateSet("Windows", "Linux")]
#         [string]$PathType = "Windows"
#     )

#     Begin {
#         Write-Host "Starting path validation..."
#     }

#     Process {
#         try {
#             Write-Host "Validating $PathType path: $Path"

#             if ($PathType -eq "Windows") {
#                 if (-not [System.IO.Path]::IsPathRooted($Path)) {
#                     throw "The Windows path is not a valid rooted path: $Path"
#                 }
#                 if (-not (Test-Path $Path)) {
#                     throw "The Windows path does not exist: $Path"
#                 }
#             } elseif ($PathType -eq "Linux") {
#                 if (-not $Path.StartsWith("/")) {
#                     throw "The Linux path is not valid, it must start with '/': $Path"
#                 }
#             }

#             Write-Host "$PathType path is valid: $Path"
#         } catch {
#             Write-Host "Error during validation: $_"
#             throw
#         }
#     }

#     End {
#         Write-Host "Path validation completed."
#     }
# }

# # Example usage:
# $winPath = 'C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1'
# $linuxPath = Convert-And-Validate-Path -WindowsPath $winPath
# Write-Host "Linux path: $linuxPath"






# <#
# .SYNOPSIS
#     Converts a Windows file path to a Linux file path and validates both before and after conversion.

# .DESCRIPTION
#     This function takes a Windows file path as input, validates it, converts it to a Linux file path,
#     and then validates the converted Linux path. It assumes a mapping from a base Windows path to a base Linux path.

# .PARAMETER WindowsPath
#     The full file path in Windows format that needs to be converted.

# .PARAMETER WindowsBasePath
#     The base directory path in Windows from which the relative path begins. Default is 'C:\Code'.

# .PARAMETER LinuxBasePath
#     The base directory path in Linux where the Windows base path is mapped. Default is '/usr/src'.
# #>
# function Convert-And-Validate-Path {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$WindowsPath,

#         [string]$WindowsBasePath = 'C:\Code',

#         [string]$LinuxBasePath = '/usr/src'
#     )

#     Begin {
#         Write-Host "Starting the path conversion process..."
#         Validate-FilePath -Path $WindowsPath -PathType "Windows"
#     }

#     Process {
#         try {
#             if (-not $WindowsPath.StartsWith($WindowsBasePath, [System.StringComparison]::OrdinalIgnoreCase)) {
#                 throw "The provided Windows path does not start with the expected base path: $WindowsBasePath"
#             }

#             Write-Host "Input Windows Path: $WindowsPath"
#             Write-Host "Converting to relative path..."

#             $relativePath = $WindowsPath.Substring($WindowsBasePath.Length).Replace('\', '/')
#             $linuxPath = $LinuxBasePath + $relativePath

#             Write-Host "Converted Linux Path: $linuxPath"
#             Validate-FilePath -Path $linuxPath -PathType "Linux"

#             return $linuxPath
#         } catch {
#             Write-Host "Error during conversion: $_"
#             throw
#         }
#     }

#     End {
#         Write-Host "Path conversion completed."
#     }
# }

# <#
# .SYNOPSIS
#     Validates a file path to ensure it meets expected criteria for either Windows or Linux systems.

# .DESCRIPTION
#     This function validates whether a given file path is correctly formatted and, for Windows paths, whether it exists.
#     It supports both Windows and Linux path formats and throws an error if the path is invalid.

# .PARAMETER Path
#     The file path to be validated.

# .PARAMETER PathType
#     The type of the path to be validated. Must be either "Windows" or "Linux". Default is "Windows".

# .EXAMPLE
#     PS> Validate-FilePath -Path 'C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1' -PathType 'Windows'
#     Validates the Windows file path.

# .EXAMPLE
#     PS> Validate-FilePath -Path '/usr/src/CB/Entra/ARH/Get-EntraConnectSyncErrorsfromEntra copy.ps1' -PathType 'Linux'
#     Validates the Linux file path.
# #>
# function Validate-FilePath {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$Path,

#         [ValidateSet("Windows", "Linux")]
#         [string]$PathType = "Windows"
#     )

#     Begin {
#         Write-Host "Starting path validation..."
#     }

#     Process {
#         try {
#             Write-Host "Validating $PathType path: $Path"

#             if ($PathType -eq "Windows") {
#                 if (-not ([System.IO.Path]::IsPathRooted($Path) -and $Path -match "^[a-zA-Z]:\\")) {
#                     throw "The Windows path is not a valid rooted path: $Path"
#                 }
#                 if (-not (Test-Path $Path)) {
#                     throw "The Windows path does not exist: $Path"
#                 }
#             } elseif ($PathType -eq "Linux") {
#                 if (-not $Path.StartsWith("/")) {
#                     throw "The Linux path is not valid, it must start with '/': $Path"
#                 }
#             }

#             Write-Host "$PathType path is valid: $Path"
#         } catch {
#             Write-Host "Error during validation: $_"
#             throw
#         }
#     }

#     End {
#         Write-Host "Path validation completed."
#     }
# }

# # Example usage:
# $winPath = 'C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1'
# $linuxPath = Convert-And-Validate-Path -WindowsPath $winPath
# Write-Host "Linux path: $linuxPath"






# function Log-Params {
#     param (
#         [hashtable]$Params
#     )

#     foreach ($key in $Params.Keys) {
#         write-host "$key $($Params[$key])"
#     }
# }



# <#
# .SYNOPSIS
# Validates if a given file path is valid and exists on the file system.

# .DESCRIPTION
# This function takes a file path as input and checks if it is a valid, rooted path and if the file exists.

# .PARAMETER Path
# The file path to validate.

# .OUTPUTS
# None

# .NOTES
# None

# .EXAMPLE
# PS> Validate-FilePath -Path "C:\path\to\file.txt"
# #>

# function Validate-FilePath {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$Path
#     )

#     begin {
#         write-host "Starting path validation..."
#         Log-Params -Params @{Path = $Path}
#     }

#     process {
#         try {
#             if (![System.IO.Path]::IsPathRooted($Path)) {
#                 throw "The Windows path is not a valid rooted path: $Path"
#             }

#             if (-not (Test-Path -Path $Path -PathType Leaf)) {
#                 throw "The file does not exist: $Path"
#             }

#             write-host "Path validation successful."
#         } catch {
#             write-host "Error during validation: $_"
#             throw $_
#         }
#     }

#     end {
#         write-host "Completed path validation."
#     }
# }







# <#
# .SYNOPSIS
# Converts a Windows file path to a Linux file path.

# .DESCRIPTION
# This function takes a Windows file path and converts it to its equivalent Linux file path.

# .PARAMETER WindowsPath
# The Windows file path to convert.

# .OUTPUTS
# string

# .NOTES
# None

# .EXAMPLE
# PS> Convert-WindowsPathToLinuxPath -WindowsPath "C:\path\to\file.txt"
# #>

# function Convert-WindowsPathToLinuxPath {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$WindowsPath
#     )

#     begin {
#         write-host "Starting the path conversion process..."
#         Log-Params -Params @{WindowsPath = $WindowsPath}
#     }

#     process {
#         try {
#             Validate-FilePath -Path $WindowsPath

#             # Replace backslashes with forward slashes
#             $LinuxPath = $WindowsPath -replace '\\', '/'

#             # Remove the drive letter and colon
#             $LinuxPath = $LinuxPath -replace '^[A-Za-z]:', ''

#             # Prefix with /mnt/driveletter
#             $DriveLetter = $WindowsPath.Substring(0, 1).ToLower()
#             $LinuxPath = "/mnt/$DriveLetter$LinuxPath"

#             write-host "Path conversion successful: $LinuxPath"
#             return $LinuxPath
#         } catch {
#             write-host "Error during path conversion: $_"
#             throw $_
#         }
#     }

#     end {
#         write-host "Completed the path conversion process."
#     }
# }






# try {
#     $linuxPath = Convert-WindowsPathToLinuxPath -WindowsPath "C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1"
#     Write-Host "Converted Path: $linuxPath"
# } catch {
#     Write-Host "An error occurred: $_"
# }













function Log-Params {
    param (
        [hashtable]$Params
    )

    foreach ($key in $Params.Keys) {
        Write-Host "$key $($Params[$key])"
    }
}

<#
.SYNOPSIS
Validates if a given file path is valid and exists on the file system.

.DESCRIPTION
This function takes a file path as input and checks if it is a valid, rooted path and if the file exists.

.PARAMETER Path
The file path to validate.

.OUTPUTS
None

.NOTES
None

.EXAMPLE
PS> Validate-FilePath -Path "C:\path\to\file.txt"
#>
function Validate-FilePath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    begin {
        Write-Host "Starting path validation..."
        Log-Params -Params @{Path = $Path}
    }

    process {
        try {
            if (![System.IO.Path]::IsPathRooted($Path)) {
                throw "The Windows path is not a valid rooted path: $Path"
            }

            if (-not (Test-Path -Path $Path -PathType Leaf)) {
                throw "The file does not exist: $Path"
            }

            Write-Host "Path validation successful."
        } catch {
            Write-Host "Error during validation: $_"
            throw $_
        }
    }

    end {
        Write-Host "Completed path validation."
    }
}

<#
.SYNOPSIS
Converts a Windows file path to a Linux file path.

.DESCRIPTION
This function takes a Windows file path and converts it to its equivalent Linux file path.

.PARAMETER WindowsPath
The Windows file path to convert.

.OUTPUTS
string

.NOTES
None

.EXAMPLE
PS> Convert-WindowsPathToLinuxPath -WindowsPath "C:\path\to\file.txt"
#>
function Convert-WindowsPathToLinuxPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$WindowsPath
    )

    begin {
        Write-Host "Starting the path conversion process..."
        Log-Params -Params @{WindowsPath = $WindowsPath}
    }

    process {
        try {
            Validate-FilePath -Path $WindowsPath

            # Replace backslashes with forward slashes
            $LinuxPath = $WindowsPath -replace '\\', '/'

            # Remove the drive letter and colon
            $LinuxPath = $LinuxPath -replace '^[A-Za-z]:', ''

            # Prefix with /mnt/driveletter
            $DriveLetter = $WindowsPath.Substring(0, 1).ToLower()
            $LinuxPath = "/mnt/$DriveLetter$LinuxPath"

            Write-Host "Path conversion successful: $LinuxPath"
            return $LinuxPath
        } catch {
            Write-Host "Error during path conversion: $_"
            throw $_
        }
    }

    end {
        Write-Host "Completed the path conversion process."
    }
}

try {
    $scriptPath = "C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1"
    Write-Host "Validating and converting the path: $scriptPath"

    if ($null -eq $scriptPath -or $scriptPath.Trim().Length -eq 0) {
        throw "The provided script path is null or empty."
    }

    $linuxPath = Convert-WindowsPathToLinuxPath -WindowsPath $scriptPath
    Write-Host "Converted Path: $linuxPath"
} catch {
    Write-Host "An error occurred: $_"
}









# $scriptPath = "/usr/src/CB/Entra/ARH/Get-EntraConnectSyncErrorsfromEntra copy.ps1"
$scriptPath = $linuxPath

# Check if the script exists before attempting to run it
if (Test-Path -Path $scriptPath) {
    Write-Host "Running script: $scriptPath"
    
    # Execute the script
    & $scriptPath
    
    Write-Host "Script execution completed successfully."
}
else {
    Write-Error "Script file not found: $scriptPath"
}
