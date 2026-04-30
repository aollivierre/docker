# Test Windows Container
Write-Host "=== Container Information ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Windows Version:" -ForegroundColor Yellow
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsArchitecture | Format-List

Write-Host "PowerShell Version:" -ForegroundColor Yellow
$PSVersionTable.PSVersion | Format-List

Write-Host "Available Commands:" -ForegroundColor Yellow
Write-Host "- PowerShell: $((Get-Command powershell -ErrorAction SilentlyContinue).Count) found"
Write-Host "- CMD: $((Get-Command cmd -ErrorAction SilentlyContinue).Count) found"

Write-Host ""
Write-Host "C:\ Directory Contents:" -ForegroundColor Yellow
Get-ChildItem C:\ | Select-Object Name, Mode | Format-Table -AutoSize

Write-Host ""
Write-Host "Environment Variables (sample):" -ForegroundColor Yellow
$env:COMPUTERNAME
$env:OS
$env:PROCESSOR_ARCHITECTURE
