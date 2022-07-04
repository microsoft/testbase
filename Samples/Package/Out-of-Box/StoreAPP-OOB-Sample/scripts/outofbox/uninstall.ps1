# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

Push-Location $PSScriptRoot
./config.ps1
$exit_code = 0
$script_name = $myinvocation.mycommand.name
# You can use the following variables to construct file path
# Root folder
$root_dir = "$PSScriptRoot\..\.."
# Log folder
$log_dir = "$root_dir\logs"

$log_file = "$log_dir\$script_name.log"


if (-not (test-path -path $log_dir )) {
    New-Item -itemtype directory -path $log_dir
}

Function Log {
    Param ([string]$log_string)
    Write-Host $log_string
    Add-Content $log_file -value $log_string
}

# Step 1: Uninstall the application
Log("Uninstalling Application")
$arguments = "Get-AppxPackage -Name *$AppProcessName* | Remove-AppxPackage"
$uninstaller = Start-Process powershell.exe $arguments -wait -passthru -NoNewWindow

# Step 2: Check if uninstallation is succeeded
# Examples of common commands
#    - Check uninstall process exit code: $installer.exitcode -eq 0
#    - Check registy: Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
#    - Check installed software list: Get-WmiObject -Class Win32_Product | where name -eq "Node.js"
if ($uninstaller.exitcode -eq 0) {
    Log("Uninstallation succesful as $($uninstaller.exitcode)")
}
else {
    Log("Error: Uninstallation failed as $($uninstaller.exitcode)")
    $exit_code = $uninstaller.exitcode
}

Log("Unistallation script finished as $exit_code")
Pop-Location
exit $exit_code