# Install-LatestOpenSSH.ps1
$ErrorActionPreference = 'Stop'

# function Install-PowerShell {
#     param (
#         [string]$url,
#         [string]$destination
#     )

#     Write-Host "Downloading PowerShell from $url"
#     Invoke-WebRequest -Uri $url -OutFile "$destination\powershell.zip"
    
#     Write-Host "Expanding PowerShell archive"
#     Expand-Archive -Path "$destination\powershell.zip" -DestinationPath $destination
    
#     Write-Host "Removing PowerShell archive"
#     Remove-Item "$destination\powershell.zip" -Force
    
#     Write-Host "Installing PowerShell remoting"
#     & "$destination\pwsh.exe" -Command "$destination\Install-PowerShellRemoting.ps1"
# }

# function Install-OpenSSH {
#     param (
#         [string]$url,
#         [string]$destination
#     )

#     Write-Host "Downloading OpenSSH from $url"
#     Invoke-WebRequest -Uri $url -OutFile "$destination\openssh.zip"
    
#     Write-Host "Expanding OpenSSH archive"
#     Expand-Archive -Path "$destination\openssh.zip" -DestinationPath $destination
    
#     Write-Host "Removing OpenSSH archive"
#     Remove-Item "$destination\openssh.zip" -Force
    
#     Write-Host "Running OpenSSH installation script"
#     & "$destination\OpenSSH-Win64\Install-SSHd.ps1"
# }

function Configure-OpenSSH {
    param (
        [string]$configPath,
        [string]$bannerPath,
        [string]$destination
    )

    Write-Host "Copying SSH configuration files"
    Copy-Item -Path $configPath -Destination "$destination\OpenSSH-Win64\sshd_config" -Force
    Copy-Item -Path $bannerPath -Destination "$destination\OpenSSH-Win64\sshd_banner" -Force

    # Write-Host "Generating SSH host keys"
    # & "$destination\OpenSSH-Win64\ssh-keygen.exe" -t dsa -N "" -f "$destination\OpenSSH-Win64\ssh_host_dsa_key"
    # & "$destination\OpenSSH-Win64\ssh-keygen.exe" -t rsa -N "" -f "$destination\OpenSSH-Win64\ssh_host_rsa_key"
    # & "$destination\OpenSSH-Win64\ssh-keygen.exe" -t ecdsa -N "" -f "$destination\OpenSSH-Win64\ssh_host_ecdsa_key"
    # & "$destination\OpenSSH-Win64\ssh-keygen.exe" -t ed25519 -N "" -f "$destination\OpenSSH-Win64\ssh_host_ed25519_key"



   


}

function Create-User {
    param (
        [string]$username,
        [string]$password
    )

    Write-Host "Creating user $username"
    net user $username $password /ADD
    net localgroup "Administrators" $username /ADD
}

function Set-DefaultShell {
    param (
        [string]$shellPath
    )

    Write-Host "Setting PowerShell as default shell"
    New-Item -Path "HKLM:\SOFTWARE\OpenSSH" -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name "DefaultShell" -Value $shellPath -PropertyType string -Force
}

# # Main script execution
# $psUrl = "https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/PowerShell-7.3.6-win-x64.zip"
# $sshUrl = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.2.2.0p1-Beta/OpenSSH-Win64.zip"
$destination = "C:\"

# Install-PowerShell -url $psUrl -destination $destination
# Install-OpenSSH -url $sshUrl -destination $destination
Configure-OpenSSH -configPath "C:\sshd_config" -bannerPath "C:\sshd_banner" -destination $destination
# Create-User -username "ssh" -password "Passw0rd"
# Set-DefaultShell -shellPath "C:\PS7\pwsh.exe"







$ErrorActionPreference = 'Stop'

# Function to generate host keys
function Generate-HostKeys {
    Write-Host "Step 6: Generating host keys"
    if (-Not (Test-Path "C:\ProgramData\ssh\ssh_host_dsa_key")) {
        & "C:\OpenSSH-Win64\ssh-keygen.exe" -t dsa -N "" -f "C:\ProgramData\ssh\ssh_host_dsa_key"
    }
    if (-Not (Test-Path "C:\ProgramData\ssh\ssh_host_rsa_key")) {
        & "C:\OpenSSH-Win64\ssh-keygen.exe" -t rsa -N "" -f "C:\ProgramData\ssh\ssh_host_rsa_key"
    }
    if (-Not (Test-Path "C:\ProgramData\ssh\ssh_host_ecdsa_key")) {
        & "C:\OpenSSH-Win64\ssh-keygen.exe" -t ecdsa -N "" -f "C:\ProgramData\ssh\ssh_host_ecdsa_key"
    }
    if (-Not (Test-Path "C:\ProgramData\ssh\ssh_host_ed25519_key")) {
        & "C:\OpenSSH-Win64\ssh-keygen.exe" -t ed25519 -N "" -f "C:\ProgramData\ssh\ssh_host_ed25519_key"
    }
    Write-Host "Step 6: Host keys generated"
}

# Function to set up the user and directories
function Setup-UserAndDirectories {
    Write-Host "Step 1: Creating ssh user and setting up directories"
    
    # Create the ssh user without a password
    net user ssh /add
    
    # Add the ssh user to the Administrators group
    net localgroup Administrators ssh /add
    
    # Define the .ssh directory path
    $sshDir = "C:\Users\ssh\.ssh"
    
    # Create the .ssh directory if it does not exist
    if (-Not (Test-Path $sshDir)) {
        New-Item -Path $sshDir -ItemType Directory -Force
    }
    
    Write-Host "Step 1: Created ssh user and .ssh directory"
}

# Setup-UserAndDirectories


# Function to set up the public key
function Setup-PublicKey {
    Write-Host "Step 2: Setting up public key for ssh user"
    # Copy-Item -Path "C:\id_rsa.pub" -Destination "C:\Users\ssh\.ssh\authorized_keys" -Force

     ################################Copy SSH Keys########################################
    # Create the .ssh directory if it doesn't exist
    $sshDir = "C:\Users\ssh\.ssh"
    if (-Not (Test-Path -Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir -Force
    }
    # Copy the public key to the .ssh directory
    # Copy-Item -Path "C:\id_rsa.pub" -Destination "$sshDir\authorized_keys" -Force
    Copy-Item -Path "C:\id_rsa.pub" -Destination "$sshDir" -Force



(Get-Content -Path C:\Users\ssh\.ssh\id_rsa.pub) | Set-Content -Path C:\Users\ssh\.ssh\authorized_keys;
    # Remove-Item -Path C:\id_rsa, C:\id_rsa.pub -Force
    Remove-Item -Path C:\id_rsa.pub -Force









# Define the path to the administrators_authorized_keys file
$filePath = "C:\ProgramData\ssh\administrators_authorized_keys"

# Create the file if it doesn't exist
if (-Not (Test-Path -Path $filePath)) {
    New-Item -Path $filePath -ItemType File -Force
    Write-Host "Created file: $filePath"
} else {
    Write-Host "File already exists: $filePath"
}






# Define the SSH user
$sshUser = "ssh"

# Define the file paths
$filePath = "C:\ProgramData\ssh\administrators_authorized_keys"
$pubKeyPath = "c:\users\ssh\.ssh\id_rsa.pub"

# Define the permissions
$permissions = @(
    [pscustomobject]@{
        IdentityReference = "SYSTEM"
        FileSystemRights = "Read"
        AccessControlType = "Allow"
    },
    [pscustomobject]@{
        IdentityReference = $sshUser
        FileSystemRights = "Read"
        AccessControlType = "Allow"
    },
    [pscustomobject]@{
        IdentityReference = $sshUser
        FileSystemRights = "Write"
        AccessControlType = "Deny"
    }
)

# Get the ACL of the file
$acl = Get-Acl -Path $filePath

# Remove all existing access rules except for SYSTEM and the SSH user
$acl.Access | ForEach-Object {
    if ($_.IdentityReference -ne "NT AUTHORITY\SYSTEM" -and $_.IdentityReference -ne $sshUser) {
        $acl.RemoveAccessRule($_)
    }
}

# Add the defined permissions
foreach ($permission in $permissions) {
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $permission.IdentityReference,
        $permission.FileSystemRights,
        $permission.AccessControlType
    )
    $acl.SetAccessRule($accessRule)
}

# Apply the ACL to the file
Set-Acl -Path $filePath -AclObject $acl

Write-Host "Permissions have been set on the file: $filePath"

# Copy the content of the public key into the administrators_authorized_keys file
if (Test-Path -Path $pubKeyPath) {
    $pubKeyContent = Get-Content -Path $pubKeyPath -Raw
    Add-Content -Path $filePath -Value $pubKeyContent
    Write-Host "Public key content has been copied to: $filePath"
} else {
    Write-Host "Public key file not found: $pubKeyPath"
}




# # (Get-Content -Path C:\Users\ssh\.ssh\id_rsa.pub) | Set-Content -Path $filePath;






    Write-Host "Step 2: Copied public key to authorized_keys"
}

# Function to set permissions
function Set-Permissions {
    Write-Host "Step 3: Setting permissions for .ssh directory and authorized_keys file"
    $sshDir = "C:\Users\ssh\.ssh"
    $authorizedKeysFile = "$sshDir\authorized_keys"
    
    # Set the correct permissions
    icacls $sshDir /inheritance:r
    icacls $sshDir /grant "ssh:F"
    icacls $sshDir /grant "Administrators:F"
    icacls $sshDir /grant "System:F"
    
    icacls $authorizedKeysFile /inheritance:r
    icacls $authorizedKeysFile /grant "ssh:F"
    icacls $authorizedKeysFile /grant "Administrators:F"
    icacls $authorizedKeysFile /grant "System:F"
    Write-Host "Step 3: Permissions set for .ssh directory and authorized_keys file"
}

# Function to configure SSHD
function Configure-SSHD {
    Write-Host "Step 4: Configuring SSHD"
    $sshdConfigPath = "C:\ProgramData\ssh\sshd_config"
    $sshdConfig = @"

Port 22

Protocol 2

LogLevel DEBUG

# Authentication:

#LoginGraceTime 2m
PermitRootLogin yes
StrictModes no
#MaxAuthTries 6
#MaxSessions 10

#RSAAuthentication yes
PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes
PermitEmptyPasswords yes

Banner sshd_banner

Subsystem       sftp    sftp-server.exe

hostkeyagent \\.\pipe\openssh-ssh-agent
"@
    Set-Content -Path $sshdConfigPath -Value $sshdConfig -Force
    Write-Host "Step 4: SSHD configuration updated"
}

# Function to restart SSH service
function Restart-SSHService {
    Write-Host "Step 5: Restarting SSH service"
    Restart-Service -Name "sshd"
    Write-Host "Step 5: SSH service restarted"
}

# Execute the functions in order
try {
    Setup-UserAndDirectories
    Setup-PublicKey
    Set-Permissions
    Configure-SSHD
    Generate-HostKeys



    # Run additional installation scripts
& "C:\OpenSSH-Win64\Install-sshd.ps1"
& "C:\OpenSSH-Win64\FixHostFilePermissions.ps1" -Confirm:$false










# Start SSH service
Start-Service sshd

    Restart-SSHService
    Write-Host "SSH setup completed successfully"
} catch {
    $errorDetails = $_ | Out-String
    Write-Host "An error occurred: $errorDetails"
    throw
}















# Verify SSH configuration
$sshdConfigPath = "C:\ProgramData\ssh\sshd_config"
$sshUserHome = "C:\Users\ssh"
$authorizedKeysPath = "$sshUserHome\.ssh\authorized_keys"

# Check if sshd_config exists
if (-Not (Test-Path -Path $sshdConfigPath)) {
    Write-Host "Error: sshd_config file not found at $sshdConfigPath"
    exit 1
}

# Ensure PubkeyAuthentication is set to yes
# $configContent = Get-Content -Path $sshdConfigPath
# if ($configContent -notcontains "PubkeyAuthentication yes") {
#     Write-Host "Adding PubkeyAuthentication yes to sshd_config"
#     Add-Content -Path $sshdConfigPath -Value "PubkeyAuthentication yes"
# }

# Ensure AuthorizedKeysFile is correctly set
# if ($configContent -notcontains "AuthorizedKeysFile .ssh/authorized_keys") {
#     Write-Host "Adding AuthorizedKeysFile .ssh/authorized_keys to sshd_config"
#     Add-Content -Path $sshdConfigPath -Value "AuthorizedKeysFile .ssh/authorized_keys"
# }

# Check and fix permissions for .ssh directory
$sshDir = "$sshUserHome\.ssh"
if (-Not (Test-Path -Path $sshDir)) {
    Write-Host "Creating .ssh directory for ssh user"
    New-Item -ItemType Directory -Path $sshDir -Force
}
Write-Host "Setting permissions for .ssh directory"
# icacls $sshDir /inheritance:r /grant:r ssh:(OI)(CI)F /t

# Check and fix permissions for authorized_keys file
if (-Not (Test-Path -Path $authorizedKeysPath)) {
    Write-Host "Error: authorized_keys file not found at $authorizedKeysPath"
    exit 1
}
Write-Host "Setting permissions for authorized_keys file"
icacls $authorizedKeysPath /inheritance:r /grant:r ssh:F /t

# Restart the sshd service
Write-Host "Restarting sshd service"
Restart-Service sshd

Write-Host "Configuration and permissions have been verified and updated if necessary."














