docker exec mywindows powershell -Command "Write-Host 'Container is running Windows Server 2022'; Get-ComputerInfo | Select-Object WindowsProductName"
