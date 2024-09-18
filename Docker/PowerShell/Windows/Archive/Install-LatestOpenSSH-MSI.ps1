function Download-LatestOpenSSH {
    write-host "Step 1: Fetching the latest OpenSSH release info..."

    try {
        write-host "Step 2: Making request to GitHub API..."
        $releaseInfo = Invoke-RestMethod https://api.github.com/repos/PowerShell/Win32-OpenSSH/releases/latest
        write-host "Step 3: Successfully retrieved release info."
        
        # write-host "Release Info: $($releaseInfo | Out-String)"
        
        # write-host "Step 4: Looking for MSI asset..."
        write-host "Step 4: Looking for zip asset..."
        # $asset = $releaseInfo.assets | Where-Object { $_.name -match '.*Win64.*.msi' }
        $asset = $releaseInfo.assets | Where-Object { $_.name -match '.*Win64.*.zip' }
        
        if ($null -eq $asset) {
            throw "No suitable asset found for OpenSSH MSI."
        }

        # write-host "MSI Asset: $($asset | Out-String)"
        
        $url = $asset.browser_download_url

        if ($null -eq $url) {
            throw "Failed to retrieve the download URL for OpenSSH MSI."
        }

        write-host "Step 5: Found download URL: $url"
        
        $msiPath = "$env:TEMP\OpenSSH-Win64.msi"
        write-host "Step 6: Starting download of MSI to $msiPath"
        Start-BitsTransfer -Source $url -Destination $msiPath
        write-host "Step 7: Successfully downloaded MSI."

        if (-not (Test-Path $msiPath)) {
            throw "MSI file does not exist at path: $msiPath"
        }

        write-host "Step 8: MSI file exists at path: $msiPath"
        return $msiPath
    } catch {
        # Capture the error details
        $errorDetails = Get-Error
        $errorDetails | Format-List -Force
        return $null
    }
}



function Install-OpenSSH {
    param (
        [string]$msiPath
    )

    try {
        write-host "Step 9: Validating MSI path: $msiPath"
        if (-not (Test-Path $msiPath)) {
            throw "MSI path is invalid: $msiPath"
        }

        write-host "Step 10: Path to be passed to msiexec: $msiPath"
        
        write-host "Step 11: Installing OpenSSH from $msiPath..."
        Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait -NoNewWindow
        write-host "Step 12: OpenSSH installation complete."
    } catch {
        # Capture the error details
        $errorDetails = Get-Error
        $errorDetails | Format-List -Force
    }
}



function Validate-Service {
    param (
        [string]$ServiceName
    )
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop
        return $true
    } catch {
        Write-Host "Service '$ServiceName' was not found on this computer."
        return $false
    }
}

function Configure-OpenSSH {
    try {
        Write-Host "Step 13: Configuring and starting OpenSSH services..."

        $services = @('sshd', 'ssh-agent')

        foreach ($service in $services) {
            if (Validate-Service -ServiceName $service) {
                Set-Service -Name $service -StartupType Automatic
                Start-Service -Name $service

                Write-Host "Step 14: OpenSSH service: $service is configured and started."
            } else {
                Write-Host "Service '$service' could not be found and therefore was not configured."
            }
        }

        
    } catch {
        # Capture the error details
        $errorDetails = Get-Error
        $errorDetails | Format-List -Force
    }
}





$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Call the functions to download, install, and configure OpenSSH
$msiPath = Download-LatestOpenSSH

if ($msiPath) {
    Install-OpenSSH -msiPath $msiPath

    # Configure-OpenSSH

    write-host "Step 15: Cleaning up downloaded MSI file..."
    Remove-Item -Force $msiPath
    write-host "Step 16: Cleanup complete."

    write-host "OpenSSH installation and configuration complete."
} else {
    write-host "Failed to download OpenSSH MSI. Aborting installation."
}
