# Start with Windows Server Core
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Download and install PowerShell 7.4.3
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    $ProgressPreference = 'SilentlyContinue'; \
    Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.4.3/PowerShell-7.4.3-win-x64.msi -OutFile PowerShell.msi; \
    Start-Process msiexec.exe -Wait -ArgumentList '/package PowerShell.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1'; \
    Remove-Item -Force PowerShell.msi

# Set PowerShell 7 as the default shell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install Oh My Posh
RUN pwsh -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))"

# Add Oh My Posh to the PATH
RUN $env:Path += ';C:\Users\ContainerAdministrator\AppData\Local\Programs\oh-my-posh\bin'; \
    [Environment]::SetEnvironmentVariable('Path', $env:Path, [EnvironmentVariableTarget]::Machine)

# Verify PowerShell version and Oh My Posh installation
RUN $PSVersionTable.PSVersion; \
    oh-my-posh --version

# Install FiraCode font using Oh My Posh
RUN oh-my-posh font install "FiraCode"

# Ensure the target directory exists and copy the PowerShell profile
RUN New-Item -Path C:\Users\ContainerAdministrator\Documents -ItemType Directory -Force
COPY Microsoft.VSCode_profile.ps1 C:\Users\ContainerAdministrator\Documents\Microsoft.VSCode_profile.ps1

# Display the contents of the PowerShell profile
RUN Get-Content C:\Users\ContainerAdministrator\Documents\Microsoft.VSCode_profile.ps1
