function Start-SshAgent {
    try {
        Write-Host "Starting ssh-agent service if not already running."
        Start-Service ssh-agent
    } catch {
        Write-Host "Error starting ssh-agent service: $_"
    }
}

function Add-PrivateKeyToSshAgent {
    param (
        [string]$privateKeyPath
    )
    try {
        Write-Host "Adding private key to ssh-agent."
        ssh-add $privateKeyPath
    } catch {
        Write-Host "Error adding private key to ssh-agent: $_"
    }
}

function Ensure-SshConfigFile {
    param (
        [string]$sshConfigPath
    )
    try {
        if (Test-Path -Path $sshConfigPath) {
            Write-Host "Clearing the existing SSH config file content."
            Clear-Content -Path $sshConfigPath
        } else {
            Write-Host "SSH config file does not exist, creating a new one."
            New-Item -ItemType File -Path $sshConfigPath -Force
        }
    } catch {
        Write-Host "Error ensuring SSH config file: $_"
    }
}

function Get-ContainerDetails {
    try {
        Write-Host "Retrieving container details."
        $containers = docker ps --format '{{.ID}} {{.Names}} {{.Status}}' | ForEach-Object {
            $parts = $_ -split ' '
            Write-Host "Container: ID=$($parts[0]), Name=$($parts[1]), Status=$($parts[2])"
            [PSCustomObject]@{
                ID = $parts[0]
                Name = $parts[1]
                Status = $parts[2]
            }
        }
        return $containers
    } catch {
        Write-Host "Error retrieving container details: $_"
        return $null
    }
}

function Get-ContainerIPAddress {
    param (
        [string]$containerID
    )
    try {
        $ipAddress = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containerID
        Write-Host "Container ID: $containerID, IP Address: $ipAddress"
        return $ipAddress
    } catch {
        Write-Host "Error retrieving IP address for container: $containerID - $_"
        return $null
    }
}

function Get-ContainerFingerprints {
    param (
        [string]$ipAddress
    )
    try {
        Write-Host "Fetching fingerprints for IP: $ipAddress"
        
        $fingerprintEcdsa = ssh-keyscan -t ecdsa $ipAddress 2>&1 | Select-String -Pattern "ecdsa-sha2-nistp256" | ForEach-Object { $_.Line }
        Write-Host "ECDSA Fingerprint: $fingerprintEcdsa"

        $fingerprintEd25519 = ssh-keyscan -t ed25519 $ipAddress 2>&1 | Select-String -Pattern "ssh-ed25519" | ForEach-Object { $_.Line }
        Write-Host "ED25519 Fingerprint: $fingerprintEd25519"

        $fingerprintRsa = ssh-keyscan -t rsa $ipAddress 2>&1 | Select-String -Pattern "ssh-rsa" | ForEach-Object { $_.Line }
        Write-Host "RSA Fingerprint: $fingerprintRsa"

        $fingerprints = @($fingerprintEcdsa, $fingerprintEd25519, $fingerprintRsa)

        if ($fingerprints -and $fingerprints.Count -gt 0) {
            Write-Host "Fingerprints fetched successfully."
            return $fingerprints
        } else {
            Write-Host "No fingerprints found for IP: $ipAddress"
            return $null
        }
    } catch {
        Write-Host "Error fetching fingerprints for IP: $ipAddress - $_"
        return $null
    }
}

function Add-FingerprintsToKnownHosts {
    param (
        [string]$ipAddress,
        [array]$fingerprints,
        [string]$knownHostsFilePath
    )
    try {
        Write-Host "Adding fingerprints to known_hosts file."
        foreach ($fingerprint in $fingerprints) {
            $entry = "$fingerprint"
            Add-Content -Path $knownHostsFilePath -Value $entry
            Write-Host "Fingerprint added successfully: $entry"
        }
    } catch {
        Write-Host "Error adding fingerprints to known_hosts file: $_"
    }
}

function Update-SshConfig {
    param (
        [PSCustomObject]$container,
        [string]$ipAddress,
        [string]$sshConfigPath
    )
    try {
        Write-Host "Creating new host entry for container: $($container.Name) with IP: $ipAddress."
        $newHostEntry = @"
Host $($container.Name)
    HostName $ipAddress
    User ssh
    Port 22
    AddKeysToAgent yes
    IdentityFile $env:USERPROFILE\.ssh\id_rsa
    ForwardAgent yes
"@

        Write-Host "Appending new host entry to the SSH config file for container: $($container.Name) with IP: $ipAddress."
        Add-Content -Path $sshConfigPath -Value $newHostEntry
        Write-Host "SSH config updated successfully with new host: $($container.Name) with IP: $ipAddress."
    } catch {
        Write-Host "Error updating SSH config for container: $container.Name - $_"
    }
}

function Update-VSCodeSettings {
    param (
        [string]$containerName,
        [string]$platform = "windows",
        [string]$settingsFilePath = "$env:APPDATA\Code\User\settings.json"
    )

    try {
        if (-Not (Test-Path -Path $settingsFilePath)) {
            Write-Host "VS Code settings file not found at: $settingsFilePath"
        } else {
            $content = Get-Content -Path $settingsFilePath -Raw
            Write-Host "Reading VS Code settings file: $settingsFilePath"
            $json = $content | ConvertFrom-Json

            if ($json.PSObject.Properties.Match("remote.SSH.remotePlatform")) {
                Write-Host "Key 'remote.SSH.remotePlatform' exists."

                $remotePlatform = $json."remote.SSH.remotePlatform"

                # Remove offending keys (uncomment as needed)
                # $offendingKeys = @("whatever key you want to remove if it's causing case sensitivity issues")
                # foreach ($key in $offendingKeys) {
                #     if ($remotePlatform.PSObject.Properties.Match($key)) {
                #         Write-Host "Removing offending key: $key"
                #         $remotePlatform.PSObject.Properties.Remove($key)
                #     }
                # }

                # Convert to lower case keys
                $remotePlatformLower = @{}
                foreach ($key in $remotePlatform.PSObject.Properties.Name) {
                    $remotePlatformLower[$key.ToLower()] = $remotePlatform."$key"
                }

                # Update the JSON with container name and platform
                $remotePlatformLower[$containerName.ToLower()] = $platform

                Write-Host "Updated remote.SSH.remotePlatform:"
                Write-Host $remotePlatformLower | ConvertTo-Json -Depth 5

                # Convert back to original key casing
                $remotePlatform = [PSCustomObject]@{}
                foreach ($key in $remotePlatformLower.Keys) {
                    $originalKey = $remotePlatformLower.Keys | Where-Object { $_.ToLower() -eq $key }
                    if ($originalKey) {
                        Add-Member -InputObject $remotePlatform -MemberType NoteProperty -Name $originalKey -Value $remotePlatformLower[$key]
                    } else {
                        Add-Member -InputObject $remotePlatform -MemberType NoteProperty -Name $key -Value $remotePlatformLower[$key]
                    }
                }

                $json."remote.SSH.remotePlatform" = $remotePlatform

                # Convert the settings back to JSON
                $updatedSettingsContent = $json | ConvertTo-Json -Depth 5

                # Write the updated settings back to the file
                Write-Host "Writing updated settings to VS Code settings file: $settingsFilePath"
                $updatedSettingsContent | Set-Content -Path $settingsFilePath -Force

                Write-Host "VS Code settings updated successfully."
            } else {
                Write-Host "Key 'remote.SSH.remotePlatform' does not exist."
            }
        }
    } catch {
        Write-Host "Error updating VS Code settings: $_"
    }
}

function Open-VSCodeAndConnect {
    param (
        [string]$containerName,
        [string]$remoteFolderPath
    )
    try {
        Write-Host "Opening VS Code and SSH into the first container with name: $containerName and opening folder: $remoteFolderPath."
        code --remote ssh-remote+$containerName $remoteFolderPath
    } catch {
        Write-Host "Error opening VS Code and connecting via SSH: $_"
    }
}

# function Install-VSCodeExtension {
#     param (
#         [string]$extensionId
#     )
#     try {
#         Write-Host "Installing VS Code extension: $extensionId"
#         code --install-extension $extensionId
#         Write-Host "VS Code extension installed successfully: $extensionId"
#     } catch {
#         Write-Host "Error installing VS Code extension: $_"
#     }
# }

# Variables
$privateKeyPath = "$env:USERPROFILE\.ssh\id_rsa"
$sshConfigPath = "$env:USERPROFILE\.ssh\config"
$knownHostsFilePath = "$env:USERPROFILE\.ssh\known_hosts"
$remoteFolderPath = "c:\" # Update this path to the folder you want to open
$firstContainerIP = $null
$firstContainerName = $null
$maxWaitTime = 60 # Maximum wait time in seconds
$waitInterval = 1 # Wait interval in seconds
$initialWaitTime = 1 # Initial wait time in seconds

# Start the ssh-agent service
Start-SshAgent

# Add private key to ssh-agent
Add-PrivateKeyToSshAgent -privateKeyPath $privateKeyPath

# Ensure SSH config file is ready
Ensure-SshConfigFile -sshConfigPath $sshConfigPath

# Initial wait to allow containers to start
Write-Host "Waiting for $initialWaitTime seconds to allow containers to start."
Start-Sleep -Seconds $initialWaitTime

# Get container details
$containers = Get-ContainerDetails

# Retry if no containers are found
$retryCount = 0
$maxRetries = 10
while ($containers.Count -eq 0 -and $retryCount -lt $maxRetries) {
    Write-Host "No containers found. Retrying in $waitInterval seconds."
    Start-Sleep -Seconds $waitInterval
    $containers = Get-ContainerDetails
    $retryCount++
}

# Verify containers are retrieved correctly
if ($null -eq $containers -or $containers.Count -eq 0) {
    Write-Host "No containers found after retries. Exiting script."
    exit
}

# Loop to check for container IP
$startTime = Get-Date
while ((Get-Date) -lt $startTime.AddSeconds($maxWaitTime) -and -not $firstContainerIP) {
    foreach ($container in $containers) {
        Write-Host "Checking container: $($container.Name) with ID: $($container.ID)"
        $ipAddress = Get-ContainerIPAddress -containerID $container.ID

        if ($ipAddress) {
            Write-Host "IP address found for container: $($container.Name) - $ipAddress"
            if (-not $firstContainerIP) {
                $firstContainerIP = $ipAddress
                $firstContainerName = $container.Name
            }
            Update-SshConfig -container $container -ipAddress $ipAddress -sshConfigPath $sshConfigPath
            
            # Fetch fingerprints and update known_hosts file
            $fingerprints = Get-ContainerFingerprints -ipAddress $ipAddress
            if ($fingerprints) {
                Add-FingerprintsToKnownHosts -ipAddress $ipAddress -fingerprints $fingerprints -knownHostsFilePath $knownHostsFilePath
            }
        } else {
            Write-Host "No IP address found for container: $($container.Name)"
        }
    }
    if (-not $firstContainerIP) {
        Write-Host "No IP address found yet. Waiting for $waitInterval seconds before next check."
        Start-Sleep -Seconds $waitInterval
    }
}

# Update VS Code settings with the container name
if ($firstContainerName) {
    Write-Host "Updating VS Code settings with container name: $firstContainerName"
    Update-VSCodeSettings -containerName $firstContainerName
} else {
    Write-Host "No container name found after $maxWaitTime seconds."
}

# Open VS Code and connect to the first container
Open-VSCodeAndConnect -containerName $firstContainerName -remoteFolderPath $remoteFolderPath

# Install PowerShell extension in VS Code
# The following does not really work unless you are inside of the VS Code terminal
# Install-VSCodeExtension -extensionId "ms-vscode.powershell"
