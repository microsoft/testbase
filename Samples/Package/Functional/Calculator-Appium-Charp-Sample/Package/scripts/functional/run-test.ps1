# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# The script in functional test is used to run test cases
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

if (-not (test-path -path $log_dir )) {
    new-item -itemtype directory -path $log_dir
}

Function log {
    Param ([string]$log_string)
    write-host $log_string
    add-content $log_file -value $log_string
}

# Launch the app
# For example:
#    - If your application is under bin folder: Start-Process -FilePath "$bin_dir\MyApp.exe"
#    - Use environment variable if need: Start-Process -FilePath "$env:comspec" -ArgumentList "/c dir `"%systemdrive%\program files`""
log("Launch WinAppDriver")
$exePath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"
Start-Process $exePath

Start-Sleep -Seconds 1
$PROCESS_NAME = "WinAppDriver"

Get-Process | findstr $PROCESS_NAME > $null
if ($? -eq "True") {
    $exit_code = 0
    log("Launch successfully $PROCESS_NAME as $exit_code")
}
else {
    $exit_code = 1
    log("WinAppDriver Launch failed as $exit_code")
}

Start-Sleep -Seconds 3
pop-location

# Launch UI Test
log("Launch Functional Test")
push-location $bin_dir/TestBin

log("Path: $Env:Path")
$dotnetPath = "$env:DOTNET_ROOT\dotnet.exe"
Start-Process $dotnetPath -ArgumentList "--info" -Wait -NoNewWindow -RedirectStandardOutput $log_dir\info.txt

$dotnetArgs = "test CalculatorTest.dll --logger trx --results-directory " + "$log_dir"
Start-Process $dotnetPath -ArgumentList $dotnetArgs -Wait -NoNewWindow -RedirectStandardOutput $log_dir\runcases.txt
log("Functional script finished, Path:$log_dir")
pop-location

# Parse test result
[int] $all_failedNum = 0

Write-Host "Parse test result"
$trx = Get-ChildItem $log_dir -Filter "*.trx"
if($trx.Count -gt 0 ) {
    log("$($trx.count) trx files found in total")
}
else {
    log("No trx files were found.")
    $exit_code = 1
}

$trx | Foreach-Object{
    log("Start parse trx :" + $_.FullName)
    [xml]$resultContent = Get-Content $_.FullName
    $resultCounters = $resultContent.TestRun.ResultSummary.Counters
    log("Start parse trx : total-$($resultCounters.total) | passed-$($resultCounters.passed) | failed-$($resultCounters.failed)")
    $failedNum = $resultCounters.failed
    $all_failedNum += $failedNum
}


if($all_failedNum -gt 0) {
  log("Failed: "+$all_failedNum)
  $exit_code = 1
}

exit $exit_code
