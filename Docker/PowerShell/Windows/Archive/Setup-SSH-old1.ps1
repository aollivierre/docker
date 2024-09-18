# $ErrorActionPreference = 'Stop'
# $ProgressPreference = 'SilentlyContinue'




# # Function to configure SSH for public key authentication
# function Configure-SSH {
#     param (
#         [string]$publicKeyPath
#     )

#     Write-Output "Configuring administrators_authorized_keys file..."
#     $authorizedKeysPath = "C:\ProgramData\ssh\administrators_authorized_keys"
#     New-Item -Path "C:\ProgramData\ssh" -Name "administrators_authorized_keys" -ItemType "file" -Force
#     $publicKeyContent = Get-Content -Path $publicKeyPath
#     Set-Content -Path $authorizedKeysPath -Value $publicKeyContent

#     # Set file permissions
#     Write-Output "Setting file permissions..."
#     $acl = Get-Acl $authorizedKeysPath
#     $acl.SetAccessRuleProtection($true, $false)
#     $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }
#     $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("System", "Read", "Allow")
#     $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "Read", "Allow")
#     $acl.AddAccessRule($rule1)
#     $acl.AddAccessRule($rule2)
#     Set-Acl $authorizedKeysPath $acl
# }

# # Main script
# Install-LatestOpenSSH



















################################Setup OpenSSH Server########################################



################################Copy SSH Keys########################################


# Create the .ssh directory if it doesn't exist
$sshDir = "C:\Users\administrator\.ssh"
if (-Not (Test-Path -Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force
}

# Copy the public key to the .ssh directory
Copy-Item -Path "C:\id_rsa.pub" -Destination "$sshDir\authorized_keys" -Force

# Set correct permissions on the .ssh directory and authorized_keys file
# icacls $sshDir /grant:r ContainerAdministrator:(OI)(CI)F /inheritance:r
# icacls "$sshDir\authorized_keys" /grant:r ContainerAdministrator:F











################################Install SSH Server ##############################


# # Install and configure OpenSSH Server
# Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# # Start the SSH service
# Start-Service sshd

# # Set SSH service to start automatically
# Set-Service -Name sshd -StartupType 'Automatic'




################################Set SSH Keys Permissions##############################


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



# $publicKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"
$publicKeyPath = "C:\Users\administrator\.ssh"
Configure-SSH -publicKeyPath $publicKeyPath

Write-Output "SSH key-based authentication setup completed."


################################Disable Password AUTH ##############################


# Edit the sshd_config file
$sshdConfigPath = "C:\ProgramData\SSH\sshd_config"
if (-Not (Test-Path -Path $sshdConfigPath)) {
    throw "sshd_config file not found at $sshdConfigPath"
}

# Disable password authentication
(Get-Content $sshdConfigPath) -replace 'PasswordAuthentication yes', 'PasswordAuthentication no' | Set-Content $sshdConfigPath

# Restart the sshd service to apply changes
Restart-Service sshd



# # Configure the firewall to allow SSH connections
# if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP")) {
#     New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "OpenSSH Server (sshd) In" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
# }

# Set the password for ContainerAdministrator
$password = ConvertTo-SecureString "Default1234" -AsPlainText -Force
# Set-LocalUser -Name "ContainerAdministrator" -Password $password
Set-LocalUser -Name "administrator" -Password $password