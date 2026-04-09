# 1. Define registry paths for 64-bit, 32-bit, and User-level desktop apps
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

# 2. Fetch Desktop Apps from Registry
$desktopApps = Get-ItemProperty $regPaths -ErrorAction SilentlyContinue | 
    Where-Object { $_.DisplayName -ne $null } | 
    Select-Object @{Name="AppName"; Expression={$_.DisplayName}}, 
                  @{Name="Version"; Expression={$_.DisplayVersion}}, 
                  Publisher, 
                  @{Name="Type"; Expression={"Desktop"}}

# 3. Fetch Modern/Store Apps
$storeApps = Get-AppxPackage | 
    Select-Object @{Name="AppName"; Expression={$_.Name}}, 
                  Version, 
                  Publisher, 
                  @{Name="Type"; Expression={"Store"}}

# 4. Combine and Export to CSV on your Desktop
$outputPath = "$env:USERPROFILE\Desktop\InstalledApps.csv"
($desktopApps + $storeApps) | Sort-Object AppName | Export-Csv -Path $outputPath -NoTypeInformation -Encoding utf8

Write-Host "Success! The list has been exported to: $outputPath" -ForegroundColor Green

#Set-ExecutionPolicy RemoteSigned -Scope CurrentUse