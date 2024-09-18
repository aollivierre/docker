# Define the full path to Docker executable
$dockerPath = "C:\Program Files\Docker\Docker\resources\bin\docker.exe"

# Check if Docker executable exists
if (-Not (Test-Path -Path $dockerPath)) {
    throw "Docker executable not found at $dockerPath. Please verify the installation path."
}

# Define variables for paths
$intuneDeployerPath = "C:\code\module-starter\Archive\tests"
$modulesPath = "C:\Code\Modulesv2"
$scriptBasePath = "C:\code"
$modulesBasePath = "C:\code\modulesv2"

# Docker image and container configuration
$imageName = "mcr.microsoft.com/powershell:windowsservercore-ltsc2022"
$containerName = "my_pwsh_container"

# Splatting the arguments for Start-Process
$dockerParams = @{
    FilePath  = $dockerPath
    ArgumentList = @(
        "run",
        "-it",
        "-v", "$($intuneDeployerPath + ':' + $scriptBasePath)",   # Mount Intune-Win32-Deployer folder
        "-v", "$($modulesPath + ':' + $modulesBasePath)",         # Mount Modulesv2 folder
        "--name", $containerName,                                 # Container name
        "-e", "SCRIPT_BASE_PATH=$scriptBasePath",                 # Set environment variable for script base path
        "-e", "MODULES_BASE_PATH=$modulesBasePath",               # Set environment variable for modules base path
        $imageName,                                               # Docker image name
        "powershell", "-ExecutionPolicy", "Bypass"                # Run PowerShell with ExecutionPolicy Bypass
    )
    NoNewWindow = $true  # Option to run the process without opening a new window
}

# Run the Docker command
Start-Process @dockerParams