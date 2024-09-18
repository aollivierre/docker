# Get all containers (both running and exited)
$containers = docker ps -a --format '{{.ID}} {{.Names}} {{.State}}'

# Initialize an array to store the formatted output
$output = @()

# Loop through each container and get its details
foreach ($container in $containers) {
    $parts = $container -split ' '
    $id = $parts[0]
    $name = $parts[1]
    $status = $parts[2]

    # Get the IP address of the container
    $ipAddress = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $id

    # Add the formatted details to the output array
    $output += [pscustomobject]@{
        ContainerName = $name
        IPAddress = $ipAddress
        Status = $status
    }
}

# Format the output as a table
$output | Format-Table -AutoSize
