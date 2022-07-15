# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# The first script in functional test is used to install application
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

# Step 1: Install application
# Call install commands, if the application has dependencies, install them in proper order as well
# Examples of common install commands
#    - msi: Start-Process msiexec.exe "/i myApplication.msi /quiet /L*v installation.log" -wait -passthru
#    - exe: Start-Process vs_community.exe "-q --wait --add Microsoft.Net.Component.4.7.1.TargetingPack" -wait -passthru
#    - zip: Expand-Archive -Path myApp.zip -DestinationPath ./myApp
Log("Installing Application")
Push-Location $bin_dir

$installer_name = "calculator.msi"
$arguments = "/i "+$installer_name+" /quiet /L*v "+"$log_dir"+"\atp-client-installation.log"
$installer = Start-Process msiexec.exe $arguments -wait -passthru
Pop-Location
if ($installer.exitcode -eq 0) {
    Log("Installation successful as $($installer.exitcode)")
}
else {
    Log("Error: Installation failed as $($installer.exitcode)")
    $exit_code = $installer.exitcode
}
Log("Installation finished as $exit_code")
Add-MpPreference -ExclusionPath  "C:\Program Files (x86)\Calculator\"
exit $exit_code
