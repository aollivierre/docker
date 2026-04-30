# Add current user to docker-users group
$username = $env:USERNAME
Write-Host "Adding user '$username' to 'docker-users' group..."

try {
    Add-LocalGroupMember -Group "docker-users" -Member $username -ErrorAction Stop
    Write-Host "Successfully added $username to docker-users group!" -ForegroundColor Green
    Write-Host ""
    Write-Host "IMPORTANT: You need to log out and log back in (or restart) for the changes to take effect." -ForegroundColor Yellow
} catch {
    if ($_.Exception.Message -like "*already a member*") {
        Write-Host "User $username is already a member of docker-users group." -ForegroundColor Cyan
    } else {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You may need to run this as Administrator." -ForegroundColor Yellow
    }
}

# Verify membership
Write-Host ""
Write-Host "Current group memberships:"
net localgroup docker-users
