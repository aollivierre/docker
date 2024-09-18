# Ensure the ssh-agent service is running
Write-Host "Starting ssh-agent service if not already running."
Start-Service ssh-agent

# Add your private key to the ssh-agent
$privateKeyPath = "$env:USERPROFILE\.ssh\id_rsa"
Write-Host "Adding private key to ssh-agent."
ssh-add $privateKeyPath

# Define the SSH config file path
$sshConfigPath = "$env:USERPROFILE\.ssh\config"

# Clear the content of the SSH config file if it exists
if (Test-Path -Path $sshConfigPath) {
    Write-Host "Clearing the existing SSH config file content."
    Clear-Content -Path $sshConfigPath
} else {
    Write-Host "SSH config file does not exist, creating a new one."
    New-Item -ItemType File -Path $sshConfigPath -Force
}

# Get all container details
Write-Host "Retrieving container details."
$containers = docker ps --format '{{.ID}} {{.Names}} {{.Status}}' | ForEach-Object {
    $parts = $_ -split ' '
    [PSCustomObject]@{
        ID = $parts[0]
        Name = $parts[1]
        Status = $parts[2]
    }
}

# Variable to hold the first container's IP for SSH connection
$firstContainerIP = $null

foreach ($container in $containers) {
    # Get the IP address of the container
    Write-Host "Retrieving IP address for container: $($container.Name)."
    $ipAddress = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container.ID

    # Skip containers without an IP address
    if (-not $ipAddress) {
        Write-Host "No IP address found for container: $($container.Name), skipping."
        continue
    }

    # Set the first container's IP for SSH connection
    if (-not $firstContainerIP) {
        $firstContainerIP = $ipAddress
    }

    # Create the new host entry
    Write-Host "Creating new host entry for container: $($container.Name) with IP: $ipAddress."
    $newHostEntry = @"
Host $($container.Name)
    HostName $ipAddress
    User ssh
    Port 22
    AddKeysToAgent yes
    IdentityFile $env:USERPROFILE\.ssh\id_rsa
    RemoteCommand code --wait
    ForwardAgent yes
"@

    # Append the new host entry to the SSH config file
    Write-Host "Appending new host entry to the SSH config file for container: $($container.Name) with IP: $ipAddress."
    Add-Content -Path $sshConfigPath -Value $newHostEntry

    # Output a success message
    Write-Host "SSH config updated successfully with new host: $($container.Name) with IP: $ipAddress."
}

# SSH into the first container with verbose output and public key
if ($firstContainerIP) {
    Write-Host "SSH into the first container with IP: $firstContainerIP using public key."
    ssh -i $privateKeyPath -o PreferredAuthentications=publickey -vvv ssh@$firstContainerIP
} else {
    Write-Host "No container IP address found to SSH into."
}
