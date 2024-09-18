<#
.SYNOPSIS
Enables the Microsoft Hyper-V and Containers features on Windows if they are not already enabled.

.DESCRIPTION
This function checks the current status of the Microsoft Hyper-V and Containers features on a Windows system. If either feature is found to be disabled, the function will attempt to enable it. The process includes error handling to manage any issues that arise during execution.

.EXAMPLE
PS C:\> Enable-WindowsFeatures
This example runs the Enable-WindowsFeatures function, which checks the status of the Microsoft Hyper-V and Containers features, and enables them if they are not enabled.

.NOTES
This function requires Administrator privileges to run successfully. Ensure that PowerShell is run as an Administrator before executing this function.
#>

function Enable-WindowsFeatures {
    [CmdletBinding()]
    param()

    Begin {
        # Function to check feature status
        function Check-FeatureStatus {
            param([string]$featureName)
            $feature = Get-WindowsOptionalFeature -Online -FeatureName $featureName
            return $feature.State
        }

        # Function to enable feature
        function Enable-Feature {
            param([string]$featureName)
            Enable-WindowsOptionalFeature -Online -FeatureName $featureName -All
        }
    }

    Process {
        try {
            # Check and enable Hyper-V if not enabled
            if ((Check-FeatureStatus -featureName "Microsoft-Hyper-V") -eq "Disabled") {
                Write-Host "Enabling Microsoft Hyper-V..."
                Enable-Feature -featureName "Microsoft-Hyper-V"
                Write-Host "Microsoft Hyper-V has been enabled."
            } else {
                Write-Host "Microsoft Hyper-V is already enabled."
            }

            # Check and enable Containers if not enabled
            if ((Check-FeatureStatus -featureName "Containers") -eq "Disabled") {
                Write-Host "Enabling Containers feature..."
                Enable-Feature -featureName "Containers"
                Write-Host "Containers feature has been enabled."
            } else {
                Write-Host "Containers feature is already enabled."
            }
        } catch {
            Write-Error "An error occurred: $_"
        } finally {
            Write-Host "Feature check and enable process completed."
        }
    }

    End {
        Write-Host "Operation completed."
    }
}

Enable-WindowsFeatures