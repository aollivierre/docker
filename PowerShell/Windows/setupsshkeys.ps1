$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Function to download and install the latest OpenSSH
function Install-LatestOpenSSH {
    Write-Output "Fetching the latest OpenSSH release info..."
    
    # Get the latest release info from GitHub
    $releaseInfo = Invoke-RestMethod https://api.github.com/repos/PowerShell/Win32-OpenSSH/releases/latest
    $asset = $releaseInfo.assets | Where-Object { $_.name -like '*Win64.zip' }
    $url = $asset.browser_download_url

    Write-Output "Downloading OpenSSH from $url..."

    # Download the file using BITS
    $zipPath = "$env:TEMP\OpenSSH-Win64.zip"
    Start-BitsTransfer -Source $url -Destination $zipPath

    Write-Output "Extracting OpenSSH..."
    $extractPath = "C:\Program Files\OpenSSH"
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

    Write-Output "Running install-sshd.ps1..."
    & "$extractPath\install-sshd.ps1"

    # Set services to Automatic and start them
    Write-Output "Configuring and starting OpenSSH services..."
    Set-Service -Name sshd -StartupType Automatic
    Set-Service -Name ssh-agent -StartupType Automatic
    Start-Service -Name sshd
    Start-Service -Name ssh-agent

    # Clean up
    Remove-Item -Force $zipPath

    Write-Output "OpenSSH installation complete."
}

# Function to generate SSH keys using PuTTY
function Generate-SSHKeys {
    param (
        [string]$puttyGenPath,
        [string]$publicKeyPath,
        [string]$privateKeyPath
    )

    Write-Output "Generating SSH keys with PuTTY..."
    Start-Process -FilePath $puttyGenPath -ArgumentList "-t rsa -b 2048 -o $publicKeyPath -O private-openssh -o $privateKeyPath -O public-openssh" -Wait
}

# Function to configure SSH for public key authentication
function Configure-SSH {
    param (
        [string]$publicKeyPath
    )

    Write-Output "Configuring administrators_authorized_keys file..."
    $authorizedKeysPath = "C:\ProgramData\ssh\administrators_authorized_keys"
    New-Item -Path "C:\ProgramData\ssh" -Name "administrators_authorized_keys" -ItemType "file" -Force
    $publicKeyContent = Get-Content -Path $publicKeyPath
    Set-Content -Path $authorizedKeysPath -Value $publicKeyContent

    # Set file permissions
    Write-Output "Setting file permissions..."
    $acl = Get-Acl $authorizedKeysPath
    $acl.SetAccessRuleProtection($true, $false)
    $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
    $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Read", "Allow")
    $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "Read", "Allow")
    $acl.AddAccessRule($rule1)
    $acl.AddAccessRule($rule2)
    Set-Acl $authorizedKeysPath $acl
}

# Main script
Install-LatestOpenSSH

$puttyGenPath = "C:\Program Files\PuTTY\puttygen.exe"
$publicKeyPath = "C:\ProgramData\ssh\id_rsa.pub"
$privateKeyPath = "C:\ProgramData\ssh\id_rsa.ppk"

Generate-SSHKeys -puttyGenPath $puttyGenPath -publicKeyPath $publicKeyPath -privateKeyPath $privateKeyPath
Configure-SSH -publicKeyPath $publicKeyPath

Write-Output "SSH key-based authentication setup completed."
