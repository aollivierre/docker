FROM mcr.microsoft.com/windows/nanoserver:ltsc2022

ADD https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/PowerShell-7.4.2-win-x64.zip c:\\powershell.zip

# Use PowerShell to expand the archive
RUN powershell -Command "Expand-Archive -Path c:\\powershell.zip -DestinationPath c:\\PowerShell"

# Set the path environment variable
RUN setx /M PATH "%PATH%;C:\\PowerShell"

# Set PowerShell as the default shell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]






