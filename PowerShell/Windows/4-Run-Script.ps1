function Convert-WindowsPathToLinuxPath {
    <#
    .SYNOPSIS
        Converts a Windows file path to a Linux file path.

    .DESCRIPTION
        This function takes a Windows file path as input and converts it to a Linux file path.
        It assumes a mapping from a base Windows path to a base Linux path which can be customized.

    .PARAMETER WindowsPath
        The full file path in Windows format that needs to be converted.

    .PARAMETER WindowsBasePath
        The base directory path in Windows from which the relative path begins. Default is 'C:\Code'.

    .PARAMETER LinuxBasePath
        The base directory path in Linux where the Windows base path is mapped. Default is '/usr/src'.

    .EXAMPLE
        PS> Convert-WindowsPathToLinuxPath -WindowsPath 'C:\Code\CB\Entra\ARH\Get-EntraConnectSyncErrorsfromEntra copy.ps1'
        Returns '/usr/src/CB/Entra/ARH/Get-EntraConnectSyncErrorsfromEntra copy.ps1'

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$WindowsPath,

        [string]$WindowsBasePath = 'C:\',

        [string]$LinuxBasePath = '/usr/src'
    )

    Begin {
        Write-Host "Starting the path conversion process..."
    }

    Process {
        try {

            Write-Host "Input Windows Path: $WindowsPath"
            Write-Host "Converting to relative path..."

            if (-not $WindowsPath.StartsWith($WindowsBasePath, [System.StringComparison]::OrdinalIgnoreCase)) {
                throw "The provided Windows path does not start with the expected base path: $WindowsBasePath"
            }

          
            # Remove the Windows base path and replace backslashes with forward slashes
            $relativePath = $WindowsPath.Substring($WindowsBasePath.Length).TrimStart('\').Replace('\', '/')

            # Construct the full Linux path
            $linuxPath = "$LinuxBasePath/$relativePath"
            Write-Host "Converted Linux Path: $linuxPath"

            return $linuxPath
        }
        catch {
            Write-Host "Error during conversion: $_"
            throw
        }
    }

    End {
        Write-Host "Path conversion completed."
    }
}

function Run-Script {
    <#
    .SYNOPSIS
    Checks if a specified script exists and runs it if it does.

    .DESCRIPTION
    This function takes a script path as input, verifies the script exists, and then runs it. If the script file does not exist, it logs an error message.

    .PARAMETER ScriptPath
    The path to the script file that needs to be checked and executed.

    .OUTPUTS
    None

    .NOTES
    This function uses try/catch for error handling and ensures the script path is validated before execution.

    .EXAMPLE
    PS> Run-Script -ScriptPath "/usr/src/CB/DotNet/Graph/Httpclient/2-List-DeletedUsers-MG_Graph_API-v2-PS7-Docker.ps1"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath
    )

    begin {
        Write-Host "Starting script execution process..."
        Write-Host "Validating script path: $ScriptPath"
    }

    process {
        try {
            if ($null -eq $ScriptPath -or $ScriptPath.Trim().Length -eq 0) {
                throw "The provided script path is null or empty."
            }

            if (Test-Path -Path $ScriptPath) {
                Write-Host "Running script: $ScriptPath"
                
                # Execute the script
                & $ScriptPath
                
                Write-Host "Script execution completed successfully."
            }
            else {
                throw "Script file not found: $ScriptPath"
            }
        }
        catch {
            Write-Error "An error occurred: $_"
            throw $_
        }
    }

    end {
        Write-Host "Completed script execution process."
    }
}

# Example usage
$winPath = 'C:\Code\Intune-Win32-Deployer\Intune-Win32-Deployer.ps1'
# $winPath = 'C:\Code\GraphAppwithCert\Graph\0-BuildEntraAppRegCertBasedwithGraph copy 2.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 5-working-code-no-parallel.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 6.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 5-working-code-no-parallel.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 7-parallel-removed-boiler-plate.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 6-parallel.ps1'
$linuxPath = Convert-WindowsPathToLinuxPath -WindowsPath $winPath
Write-Host "Linux path: $linuxPath"

# Example usage
try {
    Run-Script -ScriptPath $linuxPath
}
catch {
    Write-Host "An error occurred during script execution: $_"
}


















# Example usage
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 2.ps1' #will come back to this one for ICTC conditional access require devices to be marked as compliant
# $winPath = 'C:\Code\CB\Entra\Universal\Graph\2.1-Exclude-Intune-App-AllConditionalAccessPolicies copy 13.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\Invoke-MgGraphRequestwithAccessToken.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\Invoke-MgGraphRequestwithAccessToken copy 3.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\Connect-MGGraphwithCert-Template-v1.1.ps1'
# $winPath = 'C:\Code\Modules\EnhancedGraphAO\3.0.0\Public\Get-MsGraphAccessTokenCert.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\Connect-MGGraphwithCert-Template-v1.1.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 3.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 4.ps1'
# $winPath = 'C:\Code\CB\Entra\ICTC\Entra\Devices\Beta\get-allauditlogs copy 5.ps1'
# $winPath = 'C:\Code\Unified365toolbox\test\validateapp.ps1'