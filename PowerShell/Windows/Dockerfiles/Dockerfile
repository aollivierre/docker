# Start with Windows Server Core
# Use the latest Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set shell to PowerShell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install PowerShell Core
RUN $url = (Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/releases/latest).assets | Where-Object { $_.name -like '*win-x64.msi' } | Select-Object -ExpandProperty browser_download_url; \
    Invoke-WebRequest -Uri $url -OutFile pwsh.msi; \
    Start-Process msiexec.exe -Wait -ArgumentList '/package pwsh.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1'; \
    Remove-Item -Force pwsh.msi

# Set PowerShell Core as the default shell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Verify installation
RUN $PSVersionTable

# Set the default command
CMD ["pwsh"]

# Get OS Product Name
RUN (Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion').ProductName

# Install Oh My Posh
RUN pwsh -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))"

# Add Oh My Posh to the PATH
RUN $env:Path += ';C:\\Users\\ContainerAdministrator\\AppData\\Local\\Programs\\oh-my-posh\\bin'; \
    [Environment]::SetEnvironmentVariable('Path', $env:Path, [EnvironmentVariableTarget]::Machine)

# Verify PowerShell version and Oh My Posh installation
RUN $PSVersionTable.PSVersion; \
    oh-my-posh --version

# Install PowerShell modules Terminal-Icons and z
RUN pwsh -Command "Install-Module -Name Terminal-Icons -Scope Allusers -Force"
RUN pwsh -Command "Install-Module -Name z -Scope Allusers -Force"

# Create the necessary directory for the PowerShell profile
RUN New-Item -ItemType Directory -Force -Path "C:\\Users\\ContainerAdministrator\\Documents\\PowerShell"

# Copy the PowerShell profile to the default path for PowerShell Core
COPY Microsoft.PowerShell_profile.ps1 C:\\Users\\ContainerAdministrator\\Documents\\PowerShell\\Microsoft.PowerShell_profile.ps1