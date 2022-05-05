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

# Step 1: Stop the application
$PROCESS_NAME = "DigitalClock"
 if (Get-Process -Name $PROCESS_NAME) {
        log("Stopping $PROCESS_NAME...")        
        Stop-process -Name $PROCESS_NAME
 }

 # Step 2: Check application is stopped successfully
 $appclosed = Get-Process -Name $PROCESS_NAME
 if ($appclosed.HasExited) {
    log("close succesful $($appclosed.HasExited)")
 }
 else {
    log("Error: close failed as $($appclosed.exitcode)")
    $exit_code = $appclosed.exitcode
 }


log("close script finished as $exit_code")
pop-location
exit $exit_code
