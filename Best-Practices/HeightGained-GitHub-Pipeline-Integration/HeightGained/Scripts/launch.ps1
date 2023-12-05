push-location $PSScriptRoot
$exit_code = 0
$script_name = $myinvocation.mycommand.name
# Root folder
$root_dir = "$PSScriptRoot\.."
# Log folder
$log_dir = "$root_dir\logs"
$log_file = "$log_dir\$script_name.log"
Write-Host $log_file

push-location $root_dir
if(-not (test-path -path $log_dir )) {
    new-item -itemtype directory -path $log_dir
}

Function log {
   Param ([string]$log_string)
   write-host $log_string
   add-content $log_file -value $log_string
}

log("Running App")
log(Get-Location)
log("Folder contents")
log(Get-ChildItem)

$arguments = " 5 5 0"
$app= Start-Process HeightGained.exe $arguments -wait -passthru
pop-location

if ($app.exitcode -eq 0) {
    log("Launch successful as $($app.exitcode)")
}
else {
    log("Error: Launch failed as $($app.exitcode)")
    $exit_code = $app.exitcode
}

exit $exit_code
