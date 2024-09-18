# Array of files and directories to check permissions for
$items = @(
    "C:\ProgramData\ssh",
    "C:\ProgramData\ssh\sshd_config",
    "C:\ProgramData\ssh\ssh_host_dsa_key",
    "C:\ProgramData\ssh\ssh_host_rsa_key",
    "C:\ProgramData\ssh\ssh_host_ecdsa_key",
    "C:\ProgramData\ssh\ssh_host_ed25519_key",
    "C:\Users\ssh\.ssh",  # Replace 'ssh_user' with the actual username
    "C:\Users\ssh\.ssh\authorized_keys"  # Replace 'ssh_user' with the actual username
)

# Function to check permissions of files and directories
function Check-ItemPermissions {
    param (
        [string]$itemPath
    )

    if (Test-Path $itemPath) {
        $acl = Get-Acl $itemPath
        Write-Host "Permissions for $itemPath"
        $acl.Access | ForEach-Object {
            Write-Host "  Identity: $($_.IdentityReference)"
            Write-Host "  Access Control Type: $($_.AccessControlType)"
            Write-Host "  Permissions: $($_.FileSystemRights)"
            Write-Host "  Inheritance Flags: $($_.InheritanceFlags)"
            Write-Host "  Propagation Flags: $($_.PropagationFlags)"
            Write-Host "  Is Inherited: $($_.IsInherited)"
            Write-Host ""
        }
    } else {
        Write-Host "$itemPath does not exist."
    }
}

# Check permissions for each file and directory
foreach ($item in $items) {
    Check-ItemPermissions -itemPath $item
}
