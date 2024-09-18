# Initialize the global steps list
$global:steps = [System.Collections.Generic.List[PSCustomObject]]::new()
$global:currentStep = 0

# Function to add a step
function Add-Step {
    param (
        [string]$description,
        [ScriptBlock]$action
    )
    $global:steps.Add([PSCustomObject]@{ Description = $description; Action = $action })
}

# Function to log and execute the current step
function Log-And-Execute-Step {
    $global:currentStep++
    $totalSteps = $global:steps.Count
    $step = $global:steps[$global:currentStep - 1]
    Write-Host "Step [$global:currentStep/$totalSteps]: $($step.Description)"
    try {
        & $step.Action
    } catch {
        Write-Host "Error in step: $($step.Description)" -ForegroundColor Red
        Write-Error $_
    }
}

# Example cleanup functions

function Remove-AllContainers {
    $containers = docker ps -a -q
    if ($containers) {
        docker rm $containers -f
        Write-Host "All containers removed." -ForegroundColor Green
    } else {
        Write-Host "No containers to remove." -ForegroundColor Yellow
    }
}

function Remove-DanglingImages {
    $danglingImages = docker images -f "dangling=true" -q
    if ($danglingImages) {
        docker rmi $danglingImages -f
        Write-Host "Dangling images removed." -ForegroundColor Green
    } else {
        Write-Host "No dangling images to remove." -ForegroundColor Yellow
    }
}

function Remove-AllImagesExcept {
    param (
        [string[]]$keepImageNames
    )
    $keepImageIds = @()
    foreach ($imageName in $keepImageNames) {
        $keepImageIds += (docker images --format "{{.ID}}" $imageName)
    }
    Write-Host "Image IDs to keep: $($keepImageIds -join ', ')"

    $allImages = docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}"
    Write-Host $allImages

    $allImageIds = docker images -q | Select-Object -Unique
    $imagesToRemove = $allImageIds | Where-Object { $_ -notin $keepImageIds }

    if ($imagesToRemove) {
        Write-Host "Images to remove: $imagesToRemove" -ForegroundColor Blue
        $removalResult = docker rmi $imagesToRemove -f
        Write-Host $removalResult -ForegroundColor Blue
        Write-Host "All other images removed." -ForegroundColor Green
    } else {
        Write-Host "No images to remove." -ForegroundColor Yellow
    }
}

function Remove-AllVolumes {
    $allVolumes = docker volume ls -q
    if ($allVolumes) {
        docker volume rm $allVolumes
        Write-Host "All volumes removed." -ForegroundColor Green
    } else {
        Write-Host "No volumes to remove." -ForegroundColor Yellow
    }
}

# Define steps before execution
Add-Step "Removing all containers..." { Remove-AllContainers }
Add-Step "Removing dangling images..." { Remove-DanglingImages }
Add-Step "Keeping specified images..." { 
    $imagesToKeep = @(
        "mcr.microsoft.com/windows/servercore:ltsc2022"
        # "my_pwsh_image_with_graphauth_20240705181637:latest"
    )
    Remove-AllImagesExcept -keepImageNames $imagesToKeep
}
Add-Step "Listing all images for debugging..." { docker images }
Add-Step "Removing all volumes..." { Remove-AllVolumes }

# Calculate total steps dynamically
$totalSteps = $global:steps.Count

# Main script execution
foreach ($step in $global:steps) {
    Log-And-Execute-Step
}