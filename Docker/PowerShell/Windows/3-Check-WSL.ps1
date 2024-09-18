wsl -l -v


# Run as Administrator
$featureName = "Microsoft-Windows-Subsystem-Linux"
$featureStatus = Get-WindowsOptionalFeature -FeatureName $featureName -Online

if ($featureStatus.State -eq "Enabled") {
    Write-Output "Windows Subsystem for Linux (WSL) is enabled."
} else {
    Write-Output "Windows Subsystem for Linux (WSL) is not enabled."
}
