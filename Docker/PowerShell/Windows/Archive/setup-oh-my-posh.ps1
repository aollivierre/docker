# Define variables for the paths
# $ohMyPoshPath = "$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\bin"
# $themesPath = "$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\themes"

# Install Oh My Posh
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))

# # Add Oh My Posh to PATH if not already added
# if (-not ($env:Path -like "*$ohMyPoshPath*")) {
#     $env:Path += ";$ohMyPoshPath"
# }

# # Set up the default theme (you can customize this with your preferred theme)
# oh-my-posh init pwsh --config "$themesPath\jandedobbeleer.omp.json" | Invoke-Expression

# # Optional: Change the PowerShell profile to load Oh My Posh on startup
# $profilePath = "$PROFILE"
# if (-not (Test-Path -Path $profilePath)) {
#     New-Item -ItemType File -Path $profilePath -Force
# }

# # Add Oh My Posh initialization to the PowerShell profile if not already added
# $profileContent = Get-Content -Path $profilePath
# if (-not ($profileContent -like "*oh-my-posh init pwsh*")) {
#     Add-Content -Path $profilePath -Value "`noh-my-posh init pwsh --config `"$themesPath\jandedobbeleer.omp.json`" | Invoke-Expression`n"
# }
