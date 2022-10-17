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

# Step 1: Launch the application
# For example:
#    - If your application is under bin folder: Start-Process -FilePath "$bin_dir\MyApp.exe"
#    - Use environment variable if need: Start-Process -FilePath "$env:comspec" -ArgumentList "/c dir `"%systemdrive%\program files`""
Log("Launch Application")
Start-Process powershell.exe -ArgumentList "Get-AppxPackage -Name *$AppProcessName*" -Wait -NoNewWindow -RedirectStandardOutput $log_dir\info.txt

$PROCESS_NAME = $AppProcessName

$retryCount = 1
While ($retryCount -lt 3) {
   Start-Process explorer.exe -ArgumentList "shell:appsFolder\$AppId"
   Start-Sleep -Seconds 10

   # Step 2: Check if the application launched successfully
   # Examples of common commands
   #    - Check if a process existed: Get-Process -Name appName
   #    - Check if a window existed: get-process | where {$_.MainWindowTitle -like "*Notepad*"}
   Get-Process | findstr $PROCESS_NAME > $null
   if ($? -eq "True") {
      Log("Launch successfully $PROCESS_NAME...")
      $exit_code = 0
      break
   }
   else {
      Log("Not launched $PROCESS_NAME, retry...")
      $retryCount++
      $exit_code = 1
   }
}

if ($exit_code -eq 1) {
   Log("Not launched $PROCESS_NAME...,after $retryCount")
}

Log("Launch script finished as $exit_code")
Pop-Location
exit $exit_code