# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

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

if (-not (test-path -path $bin_dir )) {
    new-item -itemtype directory -path $bin_dir
}

if (-not (test-path -path $log_dir )) {
    new-item -itemtype directory -path $log_dir
}

Function log {
    Param ([string]$log_string)
    write-host $log_string
    add-content $log_file -value $log_string
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
log("Download AppxPackage")
DownloadAppxPackage "https://www.microsoft.com/en-us/p/microsoft-to-do-lists-tasks-reminders/9nblggh5r558" $bin_dir

# Step 2: Install the application
log("Installing Application")

# Change the current location to bin
push-location $bin_dir

$packages = Get-ChildItem -Path "*.Appx" -Name
foreach ($package in $packages) {
    $fullPath = Resolve-Path -Path "$bin_dir/$package"
    log("Installing package:$fullPath")
    $arguments = "Add-AppxPackage -Path $fullPath"
    Start-Process powershell.exe $arguments -wait -NoNewWindow
}

$apps = Get-ChildItem -Path "*.AppxBundle" -Name
foreach ($appName in $apps) {
    $appPath = Resolve-Path -Path "$bin_dir/$appName"
    log("Installing app:$appPath")
    $arguments = "Add-AppxPackage -Path $appPath"
    $installer = Start-Process powershell.exe $arguments -wait -passthru -NoNewWindow
    if ($installer.exitcode -eq 0) {
        log("$appName Installation succesful as $($installer.exitcode)")
    }
    else {
        log("Error: $appName Installation failed as $($installer.exitcode)")
        $exit_code = $installer.exitcode
    }
}

log("Installation script finished as $exit_code")
pop-location
exit $exit_code