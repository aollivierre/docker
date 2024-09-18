function Generate-SSHKeys {
    Write-Output "Generating SSH keys..."
    
    # Define the .ssh directory in the user profile
    $sshDir = "$env:USERPROFILE\.ssh"

    # Ensure the .ssh directory exists
    if (-Not (Test-Path -Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir -Force
    }

    # Define the SSH key paths
    $privateKeyPath = Join-Path -Path $sshDir -ChildPath "id_rsa"
    $publicKeyPath = Join-Path -Path $sshDir -ChildPath "id_rsa.pub"

    # Generate SSH key pair if they don't exist
    if (-Not (Test-Path -Path $privateKeyPath) -or -Not (Test-Path -Path $publicKeyPath)) {
        ssh-keygen -t rsa -b 4096 -C "abdullah@ollivierre.ca" -f $privateKeyPath -N ""
    }

    # Output the paths for verification
    Write-Host "Private Key Path: $privateKeyPath"
    Write-Host "Public Key Path: $publicKeyPath"
}

Generate-SSHKeys


Copy-Item -Path "C:\Users\Administrator\.ssh\id_rsa.pub" -Destination "C:\Code\CB\Docker\PowerShell\Windows\configs\id_rsa.pub"
# Copy-Item -Path "C:\Users\Administrator\.ssh\id_rsa" -Destination "C:\Code\CB\Docker\PowerShell\Windows\configs\id_rsa"


Set-Location C:\code\CB\Docker\PowerShell\Windows\configs


# Generate a timestamp
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

# Define unique image, container, and volume names
$imageName = "my_pwsh_image_with_graphauth_$timestamp"
$containerName = "my_pwsh_container_$timestamp"
$codeVolumeName = "code_volume_$timestamp"
$modulesVolumeName = "modules_volume_$timestamp"
$bindVolumePath = "C:/code"

# Build the Docker image with a unique name
docker build -t $imageName .

# Create Docker named volumes
docker volume create --name $codeVolumeName
docker volume create --name $modulesVolumeName



# Construct the arguments for the docker run command
$dockerArgs = @(
    "run",
    "-it",
    "-v ${codeVolumeName}:C:/code",
    "-v ${modulesVolumeName}:C:/code/Modules",
    "-v ${bindVolumePath}:C:/bindmount",
    "--name $containerName",
    "-e SCRIPT_BASE_PATH=C:/code",
    "-e MODULES_BASE_PATH=C:/code/Modules",
    # "$imageName pwsh -ExecutionPolicy Bypass"
    "$imageName"
)

# Run the Docker container with the constructed arguments
Start-Process -NoNewWindow -FilePath "docker" -ArgumentList $dockerArgs


# Call the updateSSHConfig.ps1 script using Invoke-Expression
# Invoke-Expression -Command "C:\Code\CB\Docker\PowerShell\Windows\configs\updateSSHConfig.ps1"




# docker run -it -v "C:\Code\Intune-Win32-Deployer:C:\code" -v "C:\Code\Modules:C:\code\Modules" --name my_pwsh_container -e SCRIPT_BASE_PATH="C:\code" -e MODULES_BASE_PATH="C:\code\Modules" my_pwsh_image pwsh -ExecutionPolicy Bypass


# # Ensure the directory exists
# $intuneWin32DeployerPath = "C:\Code\Intune-Win32-Deployer"
# $modulesPath = "C:\Code\Modules"

# if (-Not (Test-Path -Path $intuneWin32DeployerPath)) {
#     New-Item -ItemType Directory -Path $intuneWin32DeployerPath
# }

# if (-Not (Test-Path -Path $modulesPath)) {
#     New-Item -ItemType Directory -Path $modulesPath
# }

# # Run the Docker container
# docker run -it -v "$intuneWin32DeployerPath:C:\code" -v "$modulesPath:C:\code\Modules" --name my_pwsh_container -e SCRIPT_BASE_PATH="C:\code" -e MODULES_BASE_PATH="C:\code\Modules" mcr.microsoft.com/powershell:windowsservercore-ltsc2022 pwsh -ExecutionPolicy Bypass


