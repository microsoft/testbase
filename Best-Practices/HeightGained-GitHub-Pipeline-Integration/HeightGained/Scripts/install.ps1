push-location $PSScriptRoot
$exit_code = 0
$script_name = $myinvocation.mycommand.name
# Root folder
$root_dir = "$PSScriptRoot\.."
# Log folder
$log_dir = "$root_dir\logs"
$log_file = "$log_dir\$script_name.log"
Write-Host $log_file

if(-not (test-path -path $log_dir )) {
    new-item -itemtype directory -path $log_dir
}

Function log {
   Param ([string]$log_string)
   write-host $log_string
   add-content $log_file -value $log_string
}

log("Installing .Net 6.0 Runtime")
$dotnet_root = "$root_dir\.dotnet"

try {
   Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1'
   ./dotnet-install.ps1 -InstallDir $dotnet_root -Version "6.0.5" -Runtime "dotnet"
   [System.Environment]::SetEnvironmentVariable("DOTNET_ROOT",$dotnet_root, [System.EnvironmentVariableTarget]::User)
   log("Installation is completed")
}
catch {
  log("An error occurred:")
  log($_)
  log($_.ScriptStackTrace)
  $exit_code = -1
}

pop-location
exit $exit_code
