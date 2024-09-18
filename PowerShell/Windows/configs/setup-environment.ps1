# Verify PowerShell installation
$PSVersionTable

# Get OS Product Name
(Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion').ProductName

# Install Oh My Posh
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))

# Add Oh My Posh to the PATH
$env:Path += ';C:\Users\ContainerAdministrator\AppData\Local\Programs\oh-my-posh\bin'
[Environment]::SetEnvironmentVariable('Path', $env:Path, [EnvironmentVariableTarget]::Machine)

# Verify PowerShell version and Oh My Posh installation
$PSVersionTable.PSVersion
oh-my-posh --version

# Install PowerShell modules
Install-Module -Name Terminal-Icons -Scope AllUsers -Force
Install-Module -Name z -Scope AllUsers -Force
Install-Module -Name Microsoft.Graph.Authentication -Scope AllUsers -Force

# Create the necessary directory for the PowerShell profile
New-Item -ItemType Directory -Force -Path "C:\Users\ContainerAdministrator\Documents\PowerShell"

# Copy the PowerShell profile to the default path for PowerShell Core
Copy-Item C:\Microsoft.PowerShell_profile.ps1 C:\Users\ContainerAdministrator\Documents\PowerShell\Microsoft.PowerShell_profile.ps1