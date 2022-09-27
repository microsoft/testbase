# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

Push-Location $PSScriptRoot
$exit_code = 0
$script_name = $myinvocation.mycommand.name
# You can use the following variables to construct file path
# Root folder
$root_dir = "$PSScriptRoot\..\.."
# Bin folder
$bin_dir = "$root_dir\bin"
# Log folder
$log_dir = "$root_dir\logs"

$log_file = "$log_dir\$script_name.log"


if(-not (test-path -path $log_dir )) {
    New-Item -itemtype directory -path $log_dir
}

Function Log {
   Param ([string]$log_string)
   Write-Host $log_string
   Add-Content $log_file -value $log_string
}

# Step 1: Uninstall the application
Log("Uninstalling Application")
# Change the current location to bin
Push-Location "..\..\bin"
if ([Environment]::Is64BitProcess) {
    $installer_name = "calculator.msi"
}
else {
    $installer_name = "calculator.msi"
}
$arguments = " /uninstall "+$installer_name+" /quiet /L*v "+"$log_dir"+"\calculator-unstallation.log"
$uninstaller = Start-Process msiexec.exe $arguments -wait -passthru
Pop-Location

# Step 2: Check if uninstallation is succeeded
# Examples of common commands
#    - Check uninstall process exit code: $installer.exitcode -eq 0
#    - Check registry: Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
#    - Check installed software list: Get-WmiObject -Class Win32_Product | where name -eq "Node.js"
if ($uninstaller.exitcode -eq 0) {
   Log("Uninstallation succesful as $($uninstaller.exitcode)")
}
else if ($uninstaller.exitcode -eq 3010) {
   Log("Uninstallation succesful as $($uninstaller.exitcode), A restart is required to complete the uninstall.")
   $exit_code = 0
}
else {
   Log("Error: Uninstallation failed as $($uninstaller.exitcode)")
   $exit_code = $uninstaller.exitcode
}

Log("Uninstallation script finished as $exit_code")
Pop-Location
exit $exit_code