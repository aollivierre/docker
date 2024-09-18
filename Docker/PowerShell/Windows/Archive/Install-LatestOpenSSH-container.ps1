$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Download-LatestOpenSSH {
    try {
        $releaseInfo = Invoke-RestMethod https://api.github.com/repos/PowerShell/Win32-OpenSSH/releases/latest
        $asset = $releaseInfo.assets | Where-Object { $_.name -match '.*Win64.*.msi' }
        
        if ($null -eq $asset) {
            throw "No suitable asset found for OpenSSH MSI."
        }

        $url = $asset.browser_download_url

        if ($null -eq $url) {
            throw "Failed to retrieve the download URL for OpenSSH MSI."
        }
        
        $msiPath = "$env:TEMP\OpenSSH-Win64.msi"
        Start-BitsTransfer -Source $url -Destination $msiPath

        if (-not (Test-Path $msiPath)) {
            throw "MSI file does not exist at path: $msiPath"
        }

        return $msiPath
    }
    catch {
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
        if (-not (Test-Path $msiPath)) {
            throw "MSI path is invalid: $msiPath"
        }
        
        Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait -NoNewWindow
    }
    catch {
        $errorDetails = Get-Error
        $errorDetails | Format-List -Force
    }
}

# function Configure-OpenSSH {
#     try {
#         # Check if 'sshd' service exists before attempting to configure
#         $sshdService = Get-Service -Name sshd -ErrorAction SilentlyContinue
#         if ($null -eq $sshdService) {
#             # Try to manually register the sshd service if it doesn't exist
#             & "C:\Program Files\OpenSSH\ssh-keygen.exe" -A
#             & "C:\Program Files\OpenSSH\install-sshd.ps1"
#             $sshdService = Get-Service -Name sshd -ErrorAction SilentlyContinue
#         }

#         if ($null -eq $sshdService) {
#             throw "Service 'sshd' was not found on computer."
#         }

#         Set-Service -Name sshd -StartupType Automatic
#         Set-Service -Name ssh-agent -StartupType Automatic
#         Start-Service -Name sshd
#         Start-Service -Name ssh-agent
#     } catch {
#         $errorDetails = Get-Error
#         $errorDetails | Format-List -Force
#     }
# }

# Main Script
try {
    $msiPath = Download-LatestOpenSSH

    if ($msiPath) {
        Install-OpenSSH -msiPath $msiPath

        # Configure-OpenSSH

        # Start ssh-agent and add the key
        $sshAgentOutput = & "C:\Program Files\OpenSSH\ssh-agent.exe"
        if ($sshAgentOutput -match "SSH_AUTH_SOCK=([^;]+);") {
            $env:SSH_AUTH_SOCK = $matches[1]
            [Environment]::SetEnvironmentVariable('SSH_AUTH_SOCK', $env:SSH_AUTH_SOCK, 'User')
            & ssh-add C:\id_rsa.pub
        }

        # Start sshd service
        Start-Service sshd

        # Keep the container running
        Start-Sleep -Seconds 3600

        Remove-Item -Force $msiPath
    }
    else {
        # No MSI to install, aborting
    }
}
catch {
    $errorDetails = Get-Error
    $errorDetails | Format-List -Force
}
