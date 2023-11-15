Push-Location $PSScriptRoot

$config = Get-Content ".\config.json" | ConvertFrom-Json

$exit_code = 0
$script_name = $MyInvocation.MyCommand.Name
# You can use the following variables to construct file path
# Root folder
$root_dir = "$PSScriptRoot\..\.."
# Bin folder
$bin_dir = "$root_dir\bin"
# Log folder
$log_dir = "$root_dir\logs"

$log_file = "$log_dir\$script_name.log"

if (-not (Test-Path -Path $log_dir )) {
    New-Item -ItemType Directory -Path $log_dir
}

function Log {
    param (
        [string]$log_string
    )
    
    Write-Host $log_string
    Add-Content $log_file -Value $log_string
}

function InstallCertificate {
    if (([string]::IsNullOrEmpty($config.signingCertName)) -or (-not (Test-Path $config.signingCertName))) {
        Log("Signing cert cannot be found")
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

Log("Installing Application")
# Change the current location to bin
Push-Location $bin_dir
# Step 1: Install the application
# begin section Commands
# Call install commands, if the application has dependencies, install them in proper order as well
# Examples of common install commands
#    - msi: Start-Process msiexec.exe "/i myApplication.msi /quiet /L*v installation.log" -Wait -PassThru
#    - exe: Start-Process vs_community.exe "-q --wait --add Microsoft.Net.Component.4.7.1.TargetingPack" -Wait -PassThru
#    - zip: Expand-Archive -Path myApp.zip -DestinationPath ./myApp
InstallCertificate
Add-AppxPackage $config.packageMSIXName
# end section Commands 

Pop-Location
Pop-Location

# Step 2: Check if installation is succeeded
# begin section Verify
# Examples of common commands
#    - Check install process exit code: $installer.exitcode -eq 0
#    - Check registry: Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
#    - Check installed software list: Get-WmiObject -Class Win32_Product | where name -eq "Node.js"
$app = Get-AppxPackage -Name "*$($config.packageIdentityName)*"
if ($app -ne $null) {
    Log("Installation successful")
    exit 0
}
else {
    Log("Error: Installation failed")
    exit -1
}
# end section Verify

Log("Installation script finished")
exit $exit_code
