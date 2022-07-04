# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# The script in functional test is used to run test cases
Push-Location $PSScriptRoot
$exit_code = 0
$script_name = $myinvocation.mycommand.name
# You can use the following variables to construct file path
# Root folder
$root_dir = "$PSScriptRoot\..\.."
# Log folder
$log_dir = "$root_dir\logs"

$log_file = "$log_dir\$script_name.log"

$test_dir = "$root_dir\bin\Testbin\Tests"

if (-not (test-path -path $log_dir )) {
    New-Item -itemtype directory -path $log_dir
}

Function Log {
    Param ([string]$log_string)
    Write-Host $log_string
    Add-Content $log_file -value $log_string
}

# Launch the WinAppDriver app
Log("Launch WinAppDriver")
$exePath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"
Start-Process $exePath

Start-Sleep -Seconds 1
$PROCESS_NAME = "WinAppDriver"

Get-Process | findstr $PROCESS_NAME > $null
if ($? -eq "True") {
    $exit_code = 0
    Log("Launch successfully $PROCESS_NAME as $exit_code")
}
else {
    $exit_code = 1
    Log("WinAppDriver Launch failed as $exit_code")
}

Start-Sleep -Seconds 3
Pop-Location

# Install Appium-Python-Client
pip install Appium-Python-Client==1.3.0
# Install Pytest
pip install pytest

# Launch UI Test
Log("Launch Functional Test")
Set-Location $test_dir

Log("Path: $Env:Path")
$pytestlog = pytest ./CalculatorTest.py
Log("Functional script finished, Path:$test_dir")
Pop-Location

Start-Sleep 60

# Parse test result
Write-Host "Parse test result"
Write-Host $pytestlog[$pytestlog.count-1]
log($pytestlog)
$exit_code = 1

exit $exit_code
