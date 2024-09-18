function Install-VSCodeExtensions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$extensionsFile
    )

    if (-not (Test-Path $extensionsFile)) {
        Write-Error "Extensions file not found: $extensionsFile"
        return
    }

    $extensionsData = Import-PowerShellDataFile $extensionsFile

    if (-not $extensionsData.ContainsKey('Extensions')) {
        Write-Error "The extensions file does not contain an 'Extensions' key."
        return
    }

    foreach ($extension in $extensionsData.Extensions) {
        Write-Host "Installing VS Code extension: $extension"
        code --install-extension $extension

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Extension $extension installed successfully." -ForegroundColor Green
        } else {
            Write-Error "Failed to install extension $extension. Exit code: $LASTEXITCODE"
        }
    }
}


Install-VSCodeExtensions -extensionsFile "c:\extensions.psd1"