# Example SSH config updater script
# Log the start of the script
Write-Host "Step 1: Starting the SSH config updater script."

# Get all container details
Write-Host "Step 2: Retrieving container details."
$containers = docker ps --format '{{.ID}} {{.Names}} {{.Status}}' | ForEach-Object {
    $parts = $_ -split ' '
    [PSCustomObject]@{
        ID = $parts[0]
        Name = $parts[1]
        Status = $parts[2]
    }
}

# Define the path to the SSH config file
$sshConfigPath = "$env:USERPROFILE\.ssh\config"

# Clear the content of the SSH config file if it exists
if (Test-Path -Path $sshConfigPath) {
    Write-Host "Step 3: Clearing the existing SSH config file content."
    Clear-Content -Path $sshConfigPath
} else {
    Write-Host "Step 3: SSH config file does not exist, creating a new one."
    New-Item -ItemType File -Path $sshConfigPath -Force
}

foreach ($container in $containers) {
    # Get the IP address of the container
    Write-Host "Step 4: Retrieving IP address for container: $($container.Name)."
    $ipAddress = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container.ID

    # Skip containers without an IP address
    if (-not $ipAddress) {
        Write-Host "Step 5: No IP address found for container: $($container.Name), skipping."
        continue
    }

    # Create the new host entry
    Write-Host "Step 6: Creating new host entry for container: $($container.Name) with IP: $ipAddress."
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
    Write-Host "Step 7: Appending new host entry to the SSH config file for container: $($container.Name) with IP: $ipAddress."
    Add-Content -Path $sshConfigPath -Value $newHostEntry

    # Output a success message
    Write-Host "Step 8: SSH config updated successfully with new host: $($container.Name) with IP: $ipAddress."
}

# Log the end of the script
Write-Host "Step 9: SSH config updater script completed."
