# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

# The script in functional test is used to setup test env
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

push-location $bin_dir
$fullFileName = "$bin_dir\dotnet-install.ps1"

log("Downloading file. Please wait...")
try {
    Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1'
}
catch {
    log("Download failed with exception: $_.Exception.Message")
    pop-location
    exit 1;
}
log("Downloading completed. Path:" + $fullFileName)

powershell $fullFileName '-Channel LTS'
if ($LASTEXITCODE -eq 0) {
    log("Installation successful as $LASTEXITCODE")
}
else {
    log("Error: Installation failed as $LASTEXITCODE")
    $exit_code = $LASTEXITCODE
}

[System.Environment]::SetEnvironmentVariable("DOTNET_ROOT", "$env:LocalAppData\Microsoft\dotnet", [EnvironmentVariableTarget]::Machine)
pop-location
exit $exit_code