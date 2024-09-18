# Define the path to the known_hosts file
$knownHostsFilePath = "$env:USERPROFILE\.ssh\known_hosts"

# Function to retrieve container details
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

# Function to retrieve container IP address
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

# Function to fetch fingerprints of the container
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

# Function to add the fingerprints to the known_hosts file
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

# Get container details
$containers = Get-ContainerDetails

# Assuming you are targeting the first container for simplicity
if ($containers.Count -gt 0) {
    $firstContainer = $containers[0]
    $firstContainerIP = Get-ContainerIPAddress -containerID $firstContainer.ID
    if ($firstContainerIP) {
        $fingerprints = Get-ContainerFingerprints -ipAddress $firstContainerIP
        if ($fingerprints) {
            Add-FingerprintsToKnownHosts -ipAddress $firstContainerIP -fingerprints $fingerprints -knownHostsFilePath $knownHostsFilePath
        }
    }
} else {
    Write-Host "No containers found."
}
