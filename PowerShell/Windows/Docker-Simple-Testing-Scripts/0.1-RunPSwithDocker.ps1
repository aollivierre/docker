


# # Define the full path to Docker executable
# $dockerPath = "C:\Program Files\Docker\Docker\resources\bin\docker.exe"

# # Check if Docker executable exists
# # Throws an error if Docker is not found at the specified path
# if (-Not (Test-Path -Path $dockerPath)) {
#     throw "Docker executable not found at $dockerPath. Please verify the installation path."
# }

# # Define variables for local paths
# # These paths will be mapped (mounted) to paths inside the Docker container
# $intuneDeployerPath = "C:\code\M365Fullv6-Timer2"  # Local path to Intune-Win32-Deployer
# $modulesPath = "C:\Code\Modulesv2"                  # Local path to Modulesv2 directory
# $scriptBasePath = "C:\code"                         # Path inside the container for scripts
# $modulesBasePath = "C:\code\modulesv2"              # Path inside the container for modules

# # Get the PS1 file path from the user (ensure it's an absolute path)
# $localScriptPath = "C:\code\M365Fullv6-Timer2\Install.ps1"  # Path to the local PowerShell script to run
# if (-Not (Test-Path $localScriptPath)) {
#     throw "The specified script file does not exist: $localScriptPath"
# }

# # Get the directory of the script and script name
# $scriptDirectory = Split-Path -Parent $localScriptPath
# $scriptFileName = Split-Path -Leaf $localScriptPath
# $containerScriptPath = "C:\scripts\$scriptFileName"  # Path inside the container where the script will be accessible

# # Define Docker image and container configuration
# $imageName = "mcr.microsoft.com/windows/servercore:ltsc2022"  # Docker image for PowerShell on Windows Server Core
# $containerName = "my_pwsh_container"                         # Name to assign to the container instance
# $ps5path = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"  # Path to PowerShell 5 in the container

# # Splatting the arguments for Start-Process to improve readability and maintainability
# $dockerParams = @{
#     FilePath  = $dockerPath  # Full path to Docker executable
#     ArgumentList = @(
#         "run",                                          # Start a new Docker container
#         "-it",                                          # Run in interactive mode with a terminal
#         "-v", "$($intuneDeployerPath + ':' + $scriptBasePath)",  # Mount local Intune-Win32-Deployer folder to container's C:\code
#         "-v", "$($modulesPath + ':' + $modulesBasePath)",        # Mount local Modulesv2 folder to container's C:\code\modulesv2
#         "-v", "$($scriptDirectory + ':' + 'C:\scripts')",        # Mount local script directory to C:\scripts in the container
#         "--name", $containerName,                       # Assign the specified name to the container
#         $imageName,                                     # Use the specified Docker image for the container
#         $ps5path,                                       # Command to run inside the container: Launch PowerShell
#         "-ExecutionPolicy", "Bypass",                   # Bypass the execution policy to allow scripts to run
#         "-NoProfile",                                   # Do not load the user's PowerShell profile inside the container
#         "-File", $containerScriptPath                   # Run the specified script inside the container
#     )
#     NoNewWindow = $true  # Run Docker in the same console window (do not open a new window)
# }

# # Run the Docker command using Start-Process with the splatted parameters
# Start-Process @dockerParams




function runpsindocker {
    param (
        [string]$localScriptPath  # The path to the local script to be passed
    )


    & "$PSScriptroot\Helpers\1-CleanupDockerContainersImages.ps1"
    $exitCode = $LASTEXITCODE
    $exitCode

    # Define the full path to Docker executable
    $dockerPath = "C:\Program Files\Docker\Docker\resources\bin\docker.exe"

    # Check if Docker executable exists
    if (-Not (Test-Path -Path $dockerPath)) {
        throw "Docker executable not found at $dockerPath. Please verify the installation path."
    }

    # Check if the script exists
    if (-Not (Test-Path $localScriptPath)) {
        throw "The specified script file does not exist: $localScriptPath"
    }

    # Define variables for local paths
    $scriptDirectory = Split-Path -Parent $localScriptPath
    $scriptFileName = Split-Path -Leaf $localScriptPath
    $containerScriptPath = "C:\scripts\$scriptFileName"  # Path inside the container

    # $intuneDeployerPath = "C:\code\M365Fullv6-Timer2"  # Example folder to mount
    $intuneDeployerPath = "C:\code"  # Example folder to mount
    $modulesPath = "C:\Code\Modulesv2"                 # Example folder to mount
    $scriptBasePath = "C:\code"
    $modulesBasePath = "C:\code\modulesv2"

    # Define Docker image and container configuration
    $imageName = "mcr.microsoft.com/windows/servercore:ltsc2022"  
    $containerName = "my_pwsh_container"
    $ps5path = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

    # Splatting the arguments for Start-Process
    $dockerParams = @{
        FilePath     = $dockerPath
        ArgumentList = @(
            "run",
            "-it",
            "-v", "$($intuneDeployerPath + ':' + $scriptBasePath)",  
            "-v", "$($modulesPath + ':' + $modulesBasePath)",       
            "-v", "$($scriptDirectory + ':' + 'C:\scripts')",        
            "--name", $containerName,                       
            $imageName,                                    
            $ps5path,                                       
            "-ExecutionPolicy", "Bypass",                   
            "-NoProfile",                                   
            "-File", $containerScriptPath                   
        )
        NoNewWindow  = $true
    }

    # Run the Docker command using Start-Process
    Start-Process @dockerParams
}

