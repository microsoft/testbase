Push-Location $PSScriptRoot

$config = Get-Content ".\config.json" | ConvertFrom-Json

$exit_code = 0
$script_name = $MyInvocation.MyCommand.Name
# You can use the following variables to construct file path
# Root folder
$root_dir = "$PSScriptRoot\..\.."
# Bin folder
$bin_dir = "$root_dir\bin"
# Log folder
$log_dir = "$root_dir\logs"

$log_file = "$log_dir\$script_name.log"

if (-not (Test-Path -Path $log_dir )) {
    New-Item -ItemType Directory -Path $log_dir
}

function Log {
    param (
        [string]$log_string
    )

    Write-Host $log_string
    Add-Content $log_file -Value $log_string
}

Log("Uninstalling Application")
# Change the current location to bin
Push-Location $bin_dir
# Step 1: Uninstall the application
# begin section Commands
$app = Get-AppxPackage -Name "*$($config.packageIdentityName)*"
Remove-AppxPackage $app.PackageFullName
# end section Commands 
Pop-Location

Log("Uninstallation script finished as $exit_code")
Pop-Location
exit $exit_code
