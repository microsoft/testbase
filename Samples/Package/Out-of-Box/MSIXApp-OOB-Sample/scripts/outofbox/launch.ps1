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

Log("Launch Application")
# Step 1: Launch the application
# For example: 
#    - If your application is under bin folder: Start-Process -FilePath "$bin_dir\MyApp.exe"
#    - Use environment variable if need: Start-Process -FilePath "$env:ComSpec" -ArgumentList "/c dir `"%SystemDrive%\Program Files`""
# begin section Commands
# Change the execution path, add -ArgumentList if need.
$app = Get-AppxPackage -Name "*$($config.packageIdentityName)*"
$info = Get-AppxPackageManifest $app.PackageFullName
$appInfo = $info.Package.Applications.Application

$exePath = $app.InstallLocation + "\" + $appInfo.Executable
Start-Process -FilePath $exePath #Please ensure the file path is correct 
# end section Commands

Start-Sleep -Seconds 3

# Step 2: Check if the application launched successfully
# Examples of common commands
#    - Check if a process existed: Get-Process -Name appName
#    - Check if a window existed: Get-Process | Where-Object {$_.MainWindowTitle -like "*Notepad*"}
# begin section Verify
# Set the process name of your App.
$PROCESS_NAME = $config.appProcessName
$lookup_process = Get-Process -Name $PROCESS_NAME
if ($lookup_process) {
   Log("Launch successfully $PROCESS_NAME...") 
   $exit_code = 0
}
else {
   Log("Not launched $PROCESS_NAME...") 
   $exit_code = 1
}
# end section Verify

Log("Launch script finished as $exit_code")
Pop-Location
exit $exit_code
