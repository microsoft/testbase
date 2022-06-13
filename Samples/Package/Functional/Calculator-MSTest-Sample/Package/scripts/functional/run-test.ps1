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

# Launch UI Test
log("Launch Functional Test")
push-location $bin_dir/TestBin

$dotnetPath = "$env:DOTNET_ROOT\dotnet.exe"
Start-Process $dotnetPath -ArgumentList "--info" -Wait -NoNewWindow -RedirectStandardOutput $log_dir\info.txt

$dotnetArgs = "test CLITest.dll --logger trx --results-directory " + "$log_dir"
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
