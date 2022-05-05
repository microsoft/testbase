push-location $PSScriptRoot
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
    new-item -itemtype directory -path $log_dir
}

Function log {
   Param ([string]$log_string)
   write-host $log_string
   add-content $log_file -value $log_string
}

# Step 1: Install the application
# Call install commands, if the application has dependencies, install them in proper order as well
# Examples of common install commands
#    - msi: Start-Process msiexec.exe "/i myApplication.msi /quiet /L*v installation.log" -wait -passthru
#    - exe: Start-Process vs_community.exe "-q --wait --add Microsoft.Net.Component.4.7.1.TargetingPack" -wait -passthru
#    - zip: Expand-Archive -Path myApp.zip -DestinationPath ./myApp
log("Installing Application")
# Change the current location to bin
push-location $bin_dir
if ([Environment]::Is64BitProcess) {
    $installer_name = "TestBaseM365DigitalClock.msi"
}
else {
    $installer_name = "TestBaseM365DigitalClock.msi"
}
$arguments = "/i "+$installer_name+" /quiet /L*v "+"$log_dir"+"\atp-client-installation.log"
$installer = Start-Process msiexec.exe $arguments -wait -passthru
pop-location

# Step 2: Check if installation is succeeded
# Examples of common commands
#    - Check install process exit code: $installer.exitcode -eq 0
#    - Check registy: Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
#    - Check installed software list: Get-WmiObject -Class Win32_Product | where name -eq "Node.js"
if ($installer.exitcode -eq 0) {
    log("Installation succesful as $($installer.exitcode)")
}
else {
    log("Error: Installation failed as $($installer.exitcode)")
    $exit_code = $installer.exitcode
}

log("Installation script finished as $exit_code")
pop-location
exit $exit_code
