# Define the path to the settings.json file
$settingsFilePath = "$env:APPDATA\Code\User\settings.json"

# Step 1: Read the JSON File
try {
    if (-Not (Test-Path -Path $settingsFilePath)) {
        Write-Host "File not found: $settingsFilePath"
    } else {
        $content = Get-Content -Path $settingsFilePath -Raw
        Write-Host "File content read successfully:"
        Write-Host $content

        # Convert JSON to a hash table for case-insensitive processing
        $json = $content | ConvertFrom-Json

        # Step 2: Check Key Existence and Handle Case Insensitivity
        if ($json.PSObject.Properties.Match("remote.SSH.remotePlatform")) {
            Write-Host "Key 'remote.SSH.remotePlatform' exists."

            $remotePlatform = $json."remote.SSH.remotePlatform"

            # Remove offending keys
            $offendingKeys = @("Ubuntu-VSCode01", "ubuntu-vscode01")
            foreach ($key in $offendingKeys) {
                if ($remotePlatform.PSObject.Properties.Match($key)) {
                    Write-Host "Removing offending key: $key"
                    $remotePlatform.PSObject.Properties.Remove($key)
                }
            }

            # Convert to lower case keys
            $remotePlatformLower = @{}
            foreach ($key in $remotePlatform.PSObject.Properties.Name) {
                $remotePlatformLower[$key.ToLower()] = $remotePlatform."$key"
            }

            # Step 3: Update the JSON with container name and platform
            $newContainerName = "my_pwsh_container_20240705162855"
            $platform = "windows"

            $remotePlatformLower[$newContainerName.ToLower()] = $platform

            Write-Host "Updated remote.SSH.remotePlatform:"
            Write-Host $remotePlatformLower | ConvertTo-Json -Depth 5

            # Convert back to original key casing
            $remotePlatform = [PSCustomObject]@{}
            foreach ($key in $remotePlatformLower.Keys) {
                $originalKey = $remotePlatformLower.Keys | Where-Object { $_.ToLower() -eq $key }
                if ($originalKey) {
                    Add-Member -InputObject $remotePlatform -MemberType NoteProperty -Name $originalKey -Value $remotePlatformLower[$key]
                } else {
                    Add-Member -InputObject $remotePlatform -MemberType NoteProperty -Name $key -Value $remotePlatformLower[$key]
                }
            }

            $json."remote.SSH.remotePlatform" = $remotePlatform

            # Convert the settings back to JSON
            $updatedSettingsContent = $json | ConvertTo-Json -Depth 5

            # Write the updated settings back to the file
            Write-Host "Writing updated settings to VS Code settings file: $settingsFilePath"
            $updatedSettingsContent | Set-Content -Path $settingsFilePath -Force

            Write-Host "VS Code settings updated successfully."
        } else {
            Write-Host "Key 'remote.SSH.remotePlatform' does not exist."
        }
    }
} catch {
    Write-Host "Error processing JSON file: $_"
}
