# PowerShell script to validate files in the root of C:\ drive

# List of files to check
$filesToCheck = @(
    "install-pwsh.ps1",
    "setup-environment.ps1",
    "Microsoft.PowerShell_profile.ps1",
    "Setup-SSH.ps1",
    "Install-LatestOpenSSH.ps1",
    "id_rsa.pub",
    "sshd_banner",
    "sshd_config",
    "Validate-Files.ps1",
    "Check-FilePermissions.ps1"
)

# Function to validate files
function Validate-Files {
    param (
        [string[]]$files
    )

    $missingFiles = @()
    foreach ($file in $files) {
        $filePath = "C:\$file"
        if (-Not (Test-Path -Path $filePath)) {
            $missingFiles += $file
        }
    }

    if ($missingFiles.Count -eq 0) {
        Write-Host "All files are present in the root of C:\ drive." -ForegroundColor Green
    } else {
        Write-Host "The following files are missing from the root of C:\ drive:" -ForegroundColor Red
        $missingFiles | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }
}

# Run validation
Validate-Files -files $filesToCheck
