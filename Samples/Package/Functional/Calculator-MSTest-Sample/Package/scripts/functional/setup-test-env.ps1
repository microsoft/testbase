# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# The script in functional test is used to setup test env
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

Push-Location $bin_dir
$fullFileName = "$bin_dir\dotnet-install.ps1"

Log("Downloading file. Please wait...")
try {
    Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1'
}
catch {
    Log("Download failed with exception: $_.Exception.Message")
    Pop-Location
    exit 1;
}
Log("Downloading completed. Path:" + $fullFileName)

powershell $fullFileName '-Channel LTS'
if ($LASTEXITCODE -eq 0) {
    Log("Installation successful as $LASTEXITCODE")
}
else {
    Log("Error: Installation failed as $LASTEXITCODE")
    $exit_code = $LASTEXITCODE
}

[System.Environment]::SetEnvironmentVariable("DOTNET_ROOT", "$env:LocalAppData\Microsoft\dotnet", [EnvironmentVariableTarget]::Machine)
Pop-Location
exit $exit_code