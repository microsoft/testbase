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

if (-not (test-path -path $bin_dir )) {
    New-Item -itemtype directory -path $bin_dir
}

Function Log {
    Param ([string]$log_string)
    Write-Host $log_string
    Add-Content $log_file -value $log_string
}

Function downloadApplication {
    Param ([string]$AppURL, [string]$Name)
    Log("Downloading file. Please wait...")
    $OutputPath = "$bin_dir\$Name"
    try {
        Invoke-WebRequest -Uri $AppURL -OutFile $OutputPath
    }
    catch {
        try {
			(New-Object System.Net.WebClient).DownloadFile($AppURL, $OutputPath)
        }
        catch {
            Log("Download $Name failed with exception: $_.Exception.Message")
            return
        }
    }

    $content = "Downloading $Name completed. Path:" + $OutputPath
    log($content)
}

# Install Windows Application Driver
downloadApplication -AppURL 'https://github.com/microsoft/WinAppDriver/releases/download/v1.2.1/WindowsApplicationDriver_1.2.1.msi' -Name 'WinAppDriver.msi'
Push-Location $bin_dir
$arguments = "/i WinAppDriver.msi /quiet /L*v " + "$log_dir" + "\WinAppDriver-installation.log"
$installer = Start-Process msiexec.exe $arguments -wait -passthru
Pop-Location

if ($installer.exitcode -eq 0) {
    Log("Installation successful as $($installer.exitcode)")
}
else {
    Log("Error: Installation failed as $($installer.exitcode)")
    $exit_code = $installer.exitcode
    exit $exit_code
}
# Turn on Developer Mode
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
Log("Installation finished as $exit_code")

# Install python
downloadApplication -AppURL 'https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe' -Name 'python-3.9.13-amd64.exe'
Push-Location $bin_dir
$arguments = "/quiet InstallAllUsers=1 PrependPath=1 /log "+"$log_dir"+"\python-installation.log"
Start-Process -FilePath python-3.9.13-amd64.exe -ArgumentList $arguments -Wait

if ($LASTEXITCODE -eq 0) {
    Log("Installation successful as $LASTEXITCODE")
}
else {
    Log("Error: Installation failed as $LASTEXITCODE")
    $exit_code = $LASTEXITCODE
    exit $exit_code
}

$addPythonPathStr = "C:\Program Files\Python39\Scripts;"
$CurrentPathStr = [System.Environment]::GetEnvironmentVariable("Path" , [EnvironmentVariableTarget]::Machine)
if ($CurrentPathStr.EndsWith(';')) {
    $ChangedPathStr = $CurrentPathStr + $addPythonPathStr
}else{
    $ChangedPathStr = $CurrentPathStr + ';' + $addPythonPathStr
}
[System.Environment]::SetEnvironmentVariable("Path", $ChangedPathStr , [EnvironmentVariableTarget]::Machine)

Pop-Location
exit $exit_code
