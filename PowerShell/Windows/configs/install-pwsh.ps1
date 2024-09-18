$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Get the latest release info
$url = (Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/releases/latest).assets | 
       Where-Object { $_.name -like '*win-x64.msi' } | 
       Select-Object -ExpandProperty browser_download_url

Write-Host "Downloading PowerShell from $url"

# Download the file using BITS
Start-BitsTransfer -Source $url -Destination "$env:TEMP\pwsh.msi"

Write-Host "Installing PowerShell..."

# Install PowerShell
Start-Process msiexec.exe -Wait -ArgumentList "/package $env:TEMP\pwsh.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1"

# Clean up
Remove-Item -Force "$env:TEMP\pwsh.msi"

Write-Host "PowerShell installation complete."