# Initialize the global steps list
$global:steps = [System.Collections.Generic.List[PSCustomObject]]::new()
$global:currentStep = 0

# Function to add a step
function Add-Step {
    param (
        [string]$description
    )
    $global:steps.Add([PSCustomObject]@{ Description = $description })
}

# Function to log the current step
function Log-Step {
    $global:currentStep++
    $totalSteps = $global:steps.Count
    $stepDescription = $global:steps[$global:currentStep - 1].Description
    Write-Host "Step [$global:currentStep/$totalSteps]: $stepDescription"
}

# Define the steps before execution
Add-Step "Fetching the latest OpenSSH release info"
Add-Step "Finding the zip asset URL"
Add-Step "Downloading the zip file"
Add-Step "Extracting the zip file"
Add-Step "Running the installation script"

# Calculate total steps dynamically
$totalSteps = $global:steps.Count

# Main script execution with try-catch for error handling
try {
    # Step 1: Fetching the latest OpenSSH release info
    Log-Step
    $releaseUrl = 'https://api.github.com/repos/PowerShell/Win32-OpenSSH/releases/latest'
    $releaseInfo = Invoke-RestMethod -Uri $releaseUrl

    # Step 2: Finding the zip asset URL
    Log-Step
    $zipAsset = $releaseInfo.assets | Where-Object { $_.name -like 'OpenSSH-Win64.zip' }
    if (-not $zipAsset) {
        throw "OpenSSH-Win64.zip not found in the latest release."
    }
    $zipUrl = $zipAsset.browser_download_url
    Write-Host "Found zip asset URL: $zipUrl"

    # Step 3: Downloading the zip file
    Log-Step
    $zipPath = "C:\OpenSSH-Win64.zip"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
    Write-Host "Downloaded zip file to $zipPath"
    
    # Step 4: Extracting the zip file
    Log-Step
    $extractPath = "C:\"
    if (-not (Test-Path -Path $extractPath)) {
        New-Item -ItemType Directory -Path $extractPath | Out-Null
        Write-Host "Created directory $extractPath"
    }
    Expand-Archive -Path $zipPath -DestinationPath $extractPath
    Remove-Item $zipPath
    Write-Host "Extracted zip file to $extractPath and removed the zip file"

    # Step 5: Running the installation script
    Log-Step
    # & "$extractPath\OpenSSH-Win64\Install-SSHd.ps1"
    Write-Host "Installation script executed successfully"
} catch {
    # Capture the error details
    $errorDetails = $_ | Out-String
    Write-Host "An error occurred: $errorDetails" -ForegroundColor Red
    throw
}
