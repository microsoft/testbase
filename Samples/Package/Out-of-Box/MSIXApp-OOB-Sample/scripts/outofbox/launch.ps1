push-location $PSScriptRoot

$config = Get-Content ".\config.json" | ConvertFrom-Json

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

if (-not (test-path -path $log_dir )) {
   new-item -itemtype directory -path $log_dir
}

Function log {
   Param ([string]$log_string)
   write-host $log_string
   add-content $log_file -value $log_string
}

log("Launch Application")
# Step 1: Launch the application
# For example: 
#    - If your application is under bin folder: Start-Process -FilePath "$bin_dir\MyApp.exe"
#    - Use environment variable if need: Start-Process -FilePath "$env:comspec" -ArgumentList "/c dir `"%systemdrive%\program files`""
# begin section Commands
# Change the execution path, add -ArgumentList if need.
$app = Get-AppxPackage -Name $config.packageIdentityName
$info = Get-AppxPackageManifest $app.PackageFullName
$appInfo = $info.Package.Applications.Application

$exePath = $app.InstallLocation + "\" + $appInfo.Executable
Start-Process -FilePath $exePath #Please ensure the file path is correct 
# end section Commands

Start-Sleep -Seconds 3

# Step 2: Check if the application launched successfully
# Examples of common commands
#    - Check if a process existed: Get-Process -Name appName
#    - Check if a window existed: get-process | where {$_.MainWindowTitle -like "*Notepad*"}
# begin section Verify
# Set the process name of your App.
$PROCESS_NAME = $config.appProcessName
$lookup_process = Get-Process -Name $PROCESS_NAME
if ($lookup_process) {
   log("Launch successfully $PROCESS_NAME...") 
   $exit_code = 0
}
else {
   log("Not launched $PROCESS_NAME...") 
   $exit_code = 1
}
# end section Verify

log("Launch script finished as $exit_code")
pop-location
exit $exit_code
