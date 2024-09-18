# Define the full path to Docker executable
$dockerPath = "C:\Program Files\Docker\Docker\resources\bin\docker.exe"

# Check if Docker executable exists
# Throws an error if Docker is not found at the specified path
if (-Not (Test-Path -Path $dockerPath)) {
    throw "Docker executable not found at $dockerPath. Please verify the installation path."
}

# Define variables for local paths
# These paths will be mapped (mounted) to paths inside the Docker container
$intuneDeployerPath = "C:\Users\Admin-Abdullah\AppData\Local\Intune-Win32-Deployer"  # Local path to Intune-Win32-Deployer
$modulesPath = "C:\Code\Modulesv2"                                                  # Local path to Modulesv2 directory
$scriptBasePath = "C:\code"                                                         # Path inside the container for scripts
$modulesBasePath = "C:\code\modulesv2"                                              # Path inside the container for modules

# Define Docker image and container configuration
$imageName = "mcr.microsoft.com/powershell:windowsservercore-ltsc2022"  # Docker image for PowerShell on Windows Server Core
$containerName = "my_pwsh_container"                                     # Name to assign to the container instance

# Splatting the arguments for Start-Process to improve readability and maintainability
$dockerParams = @{
    FilePath     = $dockerPath  # Full path to Docker executable
    ArgumentList = @(
        "run", # Start a new Docker container
        "-it", # Run in interactive mode with a terminal
        "-v", "$($intuneDeployerPath + ':' + $scriptBasePath)", # Mount local Intune-Win32-Deployer folder to container's C:\code
        "-v", "$($modulesPath + ':' + $modulesBasePath)", # Mount local Modulesv2 folder to container's C:\code\modulesv2
        "--name", $containerName, # Assign the specified name to the container
        "-e", "SCRIPT_BASE_PATH=$scriptBasePath", # Set environment variable for the script base path inside the container
        "-e", "MODULES_BASE_PATH=$modulesBasePath", # Set environment variable for the modules base path inside the container
        $imageName, # Use the specified Docker image for the container
        "powershell", # Command to run inside the container: Launch PowerShell
        "-ExecutionPolicy", "Bypass", # Bypass the execution policy to allow scripts to run
        "-NoProfile"                                   # Do not load the user's PowerShell profile inside the container
    )
    NoNewWindow  = $true  # Run Docker in the same console window (do not open a new window)
}

# Run the Docker command using Start-Process with the splatted parameters
Start-Process @dockerParams
