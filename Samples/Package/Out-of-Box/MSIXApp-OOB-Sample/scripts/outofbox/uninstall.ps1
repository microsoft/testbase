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

log("Uninstalling Application")
# Change the current location to bin
push-location $bin_dir
# Step 1: Uninstall the application
# begin section Commands
$app = Get-AppxPackage -Name $config.packageIdentityName
Remove-AppxPackage $app.PackageFullName
# end section Commands 
pop-location

log("Uninstallation script finished as $exit_code")
pop-location
exit $exit_code
