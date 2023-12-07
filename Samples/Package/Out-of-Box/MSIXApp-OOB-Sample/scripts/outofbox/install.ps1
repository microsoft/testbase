push-location $PSScriptRoot

$config = Get-Content ".\config.json" | ConvertFrom-Json

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

Function InstallCertificate() {
    if (([string]::IsNullOrEmpty($config.signingCertName)) -or (-not (Test-Path $config.signingCertName))) {
        log("Signing cert cannot be found")
        return
    }

    $secPwd = ConvertTo-SecureString -String $config.signingCertPassword -Force -AsPlainText
    $cert = Import-PfxCertificate -FilePath $config.signingCertName -CertStoreLocation Cert:\LocalMachine\My -Password $secPwd

    # Copy the certificate to Trusted Root store
    $rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList Root, LocalMachine
    $rootStore.Open("ReadWrite")
    $rootStore.Add($cert)
    $rootStore.Close()

    # Copy the certificate to Trusted Publishers store
    $pubStore = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumentList TrustedPublisher, LocalMachine
    $pubStore.Open("ReadWrite")
    $pubStore.Add($cert)
    $pubStore.Close()
}

log("Installing Application")
# Change the current location to bin
push-location $bin_dir
# Step 1: Install the application
# begin section Commands
# Call install commands, if the application has dependencies, install them in proper order as well
# Examples of common install commands
#    - msi: Start-Process msiexec.exe "/i myApplication.msi /quiet /L*v installation.log" -wait -passthru
#    - exe: Start-Process vs_community.exe "-q --wait --add Microsoft.Net.Component.4.7.1.TargetingPack" -wait -passthru
#    - zip: Expand-Archive -Path myApp.zip -DestinationPath ./myApp
InstallCertificate
Add-AppxPackage $config.packageMSIXName
# end section Commands 

pop-location
pop-location

# Step 2: Check if installation is succeeded
# begin section Verify
# Examples of common commands
#    - Check install process exit code: $installer.exitcode -eq 0
#    - Check registry: Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
#    - Check installed software list: Get-WmiObject -Class Win32_Product | where name -eq "Node.js"
$app = Get-AppxPackage -Name $config.packageIdentityName
if ($app -ne $null) {
    log("Installation successful")
    exit 0
}
else {
    log("Error: Installation failed")
    exit -1
}
# end section Verify

log("Installation script finished")
exit $exit_code
