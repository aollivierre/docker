# entrypoint.ps1

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
        Write-Host "Configuring and starting OpenSSH services..."

        $services = @('sshd', 'ssh-agent')

        foreach ($service in $services) {
            if (Validate-Service -ServiceName $service) {
                Set-Service -Name $service -StartupType Automatic
                Start-Service -Name $service
            } else {
                Write-Host "Service '$service' could not be found and therefore was not configured."
            }
        }

        Write-Host "OpenSSH services are configured and started."
    } catch {
        # Capture the error details
        $errorDetails = Get-Error
        $errorDetails | Format-List -Force
    }
}

# Call the function to configure and start OpenSSH services
Configure-OpenSSH
