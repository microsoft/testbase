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

# Step 1: Stop the application
# begin section Commands
# Set the process name of your App.

$PROCESS_NAME = $config.appProcessName
$lookup_process = Get-Process -Name $PROCESS_NAME
if ($lookup_process) {
   Log("Stopping $PROCESS_NAME...")        
   Stop-process -Name $PROCESS_NAME
}
else {
   Log("Error: cannot find process named as $($PROCESS_NAME)")
   $exit_code = 1
}
# end section Commands

# Step 2: Check application is stopped successfully
# begin section Verify
$appClosed = Get-Process -Name $PROCESS_NAME
if ($appClosed.HasExited) {
   Log("close successful $($appClosed.HasExited)")
}
else {
   Log("Error: close failed as $($appClosed.ExitCode)")
   $exit_code = 1
}
# end section Verify

Log("close script finished as $exit_code")
Pop-Location
exit $exit_code
