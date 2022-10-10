# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

Push-Location $PSScriptRoot
./config.ps1
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

if (-not (test-path -path $bin_dir )) {
    New-Item -itemtype directory -path $bin_dir
}

if (-not (test-path -path $log_dir )) {
    New-Item -itemtype directory -path $log_dir
}

Function Log {
    Param ([string]$log_string)
    Write-Host $log_string
    Add-Content $log_file -value $log_string
}

Function DownloadAppxPackage {
    param (
        [string]$Uri,
        [string]$Path = "."
    )

    process {
        $Path = (Resolve-Path $Path).Path
        #Get Urls to download
        $WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Retail" -ContentType 'application/x-www-form-urlencoded'
        #Get the link of the download package from $WebResponse via current architecture
        $LinksMatch = $WebResponse.Links | where { $_ -like '*.appx*' } | where { $_ -like '*_neutral_*' -or $_ -like "*_" + $env:PROCESSOR_ARCHITECTURE.Replace("AMD", "X").Replace("IA", "X") + "_*" } | Select-String -Pattern '(?<=a href=").+(?=" r)'
        $DownloadLinks = $LinksMatch.matches.value

        function Resolve-NameConflict {
            #Accepts Path to a FILE and changes it so there are no name conflicts
            param(
                [string]$Path
            )
            $newPath = $Path
            if (Test-Path $Path) {
                $i = 0;
                $item = (Get-Item $Path)
                while (Test-Path $newPath) {
                    $i += 1;
                    $newPath = Join-Path $item.DirectoryName ($item.BaseName + "($i)" + $item.Extension)
                }
            }
            return $newPath
        }
        #Download Urls
        foreach ($url in $DownloadLinks) {
            $FileRequest = Invoke-WebRequest -Uri $url -UseBasicParsing #-Method Head
            $FileName = ($FileRequest.Headers["Content-Disposition"] | Select-String -Pattern  '(?<=filename=).+').matches.value
            $FilePath = Join-Path $Path $FileName; $FilePath = Resolve-NameConflict($FilePath)
            [System.IO.File]::WriteAllBytes($FilePath, $FileRequest.content)
            log($FilePath)
        }
    }
}

# Step 1: Download the application from microsoft store
Log("Download AppxPackage")
DownloadAppxPackage $AppStoreURL $bin_dir

# Step 2: Install the application
Log("Installing Application")

# Change the current location to bin
Push-Location $bin_dir

$packages = Get-ChildItem -Path "*.Appx" -Name
foreach ($package in $packages) {
    $fullPath = Resolve-Path -Path "$bin_dir/$package"
    Log("Installing package:$fullPath")
    $arguments = "Add-AppxPackage -Path $fullPath"
    Start-Process powershell.exe $arguments -wait -NoNewWindow
}

$apps = Get-ChildItem -Path "*.AppxBundle" -Name
foreach ($appName in $apps) {
    $appPath = Resolve-Path -Path "$bin_dir/$appName"
    Log("Installing app:$appPath")
    $arguments = "Add-AppxPackage -Path $appPath"
    $installer = Start-Process powershell.exe $arguments -wait -passthru -NoNewWindow
    if ($installer.exitcode -eq 0) {
        Log("$appName Installation succesful as $($installer.exitcode)")
    }
    else {
        Log("Error: $appName Installation failed as $($installer.exitcode)")
        $exit_code = $installer.exitcode
    }
}

Log("Installation script finished as $exit_code")
Pop-Location
exit $exit_code
