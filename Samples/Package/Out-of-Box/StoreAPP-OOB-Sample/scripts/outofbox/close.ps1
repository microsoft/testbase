# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

Push-Location $PSScriptRoot
$exit_code = 0
$script_name = $myinvocation.mycommand.name
./config.ps1
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

# Step 1: Stop the application
$PROCESS_NAME = $AppProcessName
if (Get-Process -Name $PROCESS_NAME) {
   Log("Stopping $PROCESS_NAME...")
   Stop-Process -Name $PROCESS_NAME
}

# Step 2: Check application is stopped successfully
$appclosed = Get-Process -Name $PROCESS_NAME
if ($appclosed.HasExited) {
   Log("close succesful $($appclosed.HasExited)")
}
else {
   Log("Error: close failed as $($appclosed.exitcode)")
   $exit_code = $appclosed.exitcode
}


Log("close script finished as $exit_code")
Pop-Location
exit $exit_code
