# Start with Windows Server Core as the base image
FROM my_pwsh_image_with_graphauth_20240705181637:latest AS base

# Set shell to PowerShell and copy necessary files in one layer
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY ["setup-environment.ps1", "Microsoft.PowerShell_profile.ps1", "Setup-SSH.ps1", "Check-FilePermissions.ps1" ,"Validate-Files.ps1", "Install-LatestOpenSSH.ps1", "Install-VSCodeServer.ps1", "id_rsa.pub", "sshd_banner", "sshd_config", "Install-VSCodeExtensions.ps1" , "extensions.psd1" , "C:/"]

# Install PowerShell Core, run setup, and clean up in one layer
RUN $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine'); \
    pwsh -Command "C:/Validate-Files.ps1"; \
    pwsh -Command "C:/Install-VSCodeServer.ps1"; \
    pwsh -Command "C:/Install-LatestOpenSSH.ps1"; \
    pwsh -Command "C:/Setup-SSH.ps1"; \
    pwsh -Command "C:/Check-FilePermissions.ps1"; \
    pwsh -Command "C:/setup-environment.ps1"; \
    Remove-Item C:/install-pwsh.ps1, C:/setup-environment.ps1, C:/Install-VSCodeServer.ps1 -Force

# Expose the SSH port
EXPOSE 22

# Set PowerShell Core as the default shell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Ensure both ssh-agent and sshd services are started when the container runs
# CMD ["pwsh", "-NoExit", "-Command", "Start-Service ssh-agent; Start-Service sshd; Wait-Event -Timeout 31536000"]

# CMD ["pwsh", "-NoExit", "-Command", "Start-Service ssh-agent; Start-Service sshd; & 'C:\\vscode-server\\vscode-server-win32-x64\\bin\\remote-cli\\code.cmd' --install-extension ms-vscode.powershell"]

CMD ["pwsh", "-NoExit", "-Command", "Start-Service ssh-agent; Start-Service sshd"]