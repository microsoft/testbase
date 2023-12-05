# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# The script in functional test is used to run test cases
Push-Location $PSScriptRoot
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
    New-Item -itemtype directory -path $log_dir
}

Function Log {
    Param ([string]$log_string)
    Write-Host $log_string
    Add-Content $log_file -value $log_string
}

# Launch UI Test
Log("Launch Functional Test")
Push-Location $bin_dir/TestBin

$dotnetPath = "$env:DOTNET_ROOT\dotnet.exe"
Start-Process $dotnetPath -ArgumentList "--info" -Wait -NoNewWindow -RedirectStandardOutput $log_dir\info.txt

$dotnetArgs = "test CLITest.dll --logger trx --results-directory " + "$log_dir"
Start-Process $dotnetPath -ArgumentList $dotnetArgs -Wait -NoNewWindow -RedirectStandardOutput $log_dir\runcases.txt
Log("Functional script finished, Path:$log_dir")
Pop-Location

# Parse test result
[int] $all_failedNum = 0

Write-Host "Parse test result"
$trx = Get-ChildItem $log_dir -Filter "*.trx"
if($trx.Count -gt 0 ) {
    Log("$($trx.count) trx files found in total")
}
else {
    Log("No trx files were found.")
    $exit_code = 1
}

$trx | Foreach-Object{
    Log("Start parse trx :" + $_.FullName)
    [xml]$resultContent = Get-Content $_.FullName
    $resultCounters = $resultContent.TestRun.ResultSummary.Counters
    Log("Start parse trx : total-$($resultCounters.total) | passed-$($resultCounters.passed) | failed-$($resultCounters.failed)")
    $failedNum = $resultCounters.failed
    $all_failedNum += $failedNum
}


if($all_failedNum -gt 0) {
  Log("Failed: "+$all_failedNum)
  $exit_code = 1
}

exit $exit_code
