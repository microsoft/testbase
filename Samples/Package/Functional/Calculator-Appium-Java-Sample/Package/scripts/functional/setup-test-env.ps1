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

# Install JDK
downloadApplication -AppURL 'https://aka.ms/download-jdk/microsoft-jdk-17.0.3-windows-x64.msi' -Name 'jdk.msi'
Push-Location $bin_dir
$arguments = "/i jdk.msi /qn /log " + "$log_dir" + "\jdk-installation.log"
$installerjdk = Start-Process msiexec.exe $arguments -wait -passthru
Pop-Location
if ($installerjdk.exitcode -eq 0) {
    Log("Installation successful as $($installerjdk.exitcode)")
}
else {
    Log("Error: Installation failed as $($installerjdk.exitcode)")
    $exit_code = $installerjdk.exitcode
    exit $exit_code
}


# Install Maven
downloadApplication -AppURL 'https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.zip' -Name 'maven.zip'
Expand-Archive -Path $bin_dir'\maven.zip' -DestinationPath $bin_dir -Force
$addMvnPathStr = $bin_dir +'\apache-maven-3.8.6\bin;'
$CurrentPathStr = [System.Environment]::GetEnvironmentVariable("Path" , [EnvironmentVariableTarget]::Machine)
if ($CurrentPathStr.EndsWith(';')) {
$ChangedPathStr = $CurrentPathStr + $addMvnPathStr
}else{
    $ChangedPathStr = $CurrentPathStr + ';' + $addMvnPathStr
}
[System.Environment]::SetEnvironmentVariable("Path", $ChangedPathStr , [EnvironmentVariableTarget]::Machine)

exit $exit_code