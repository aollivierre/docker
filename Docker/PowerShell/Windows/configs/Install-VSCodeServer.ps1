# Path to download the VS Code Server
$downloadUrl = "https://update.code.visualstudio.com/latest/server-win32-x64/stable"
$zipFilePath = "C:/vscode-server-win.zip"
$extractPath = "C:/vscode-server"

# Step 1: Download the VS Code Server
Write-Host "Downloading VS Code Server from $downloadUrl..."
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFilePath
    Write-Host "Download completed successfully."
} catch {
    Write-Host "Error downloading VS Code Server: $_"
    exit 1
}

# Step 2: Extract the VS Code Server
Write-Host "Extracting VS Code Server to $extractPath..."
try {
    Expand-Archive -Path $zipFilePath -DestinationPath $extractPath
    Write-Host "Extraction completed successfully."
} catch {
    Write-Host "Error extracting VS Code Server: $_"
    exit 1
}

# Step 3: Cleanup
Write-Host "Cleaning up installation files..."
try {
    Remove-Item $zipFilePath
    Write-Host "Cleanup completed successfully."
} catch {
    Write-Host "Error cleaning up installation files: $_"
}

# Step 4: Start the VS Code Server (Corrected command)
Write-Host "Starting VS Code Server..."
try {
    Start-Process -FilePath "$extractPath/vscode-server-win32-x64/bin/code-server.cmd" -ArgumentList "--host 0.0.0.0 --port 8080" -NoNewWindow -PassThru | Wait-Process
    Write-Host "VS Code Server started successfully."
} catch {
    Write-Host "Error starting VS Code Server: $_"
}

# Step 5: Install the VS Code PowerShell extension
Write-Host "Installing VS Code PowerShell extension..."
try {
    Start-Process -FilePath "$extractPath/vscode-server-win32-x64/bin/remote-cli/code.cmd" -ArgumentList "--install-extension ms-vscode.powershell" -NoNewWindow -Wait
    Write-Host "VS Code PowerShell extension installed successfully."
} catch {
    Write-Host "Error installing VS Code PowerShell extension: $_"
}
