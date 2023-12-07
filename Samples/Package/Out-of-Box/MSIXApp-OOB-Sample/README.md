# MSIX App Out of Box Package

## MSIX App package

Click [here](https://learn.microsoft.com/en-us/windows/msix/overview) for details.

## Out of Box Test

The Out-of-Box (OOB) test is a basic compatibility test method in Test Base.

_An OOB test performs an install, launch, close, and uninstall of your application. After the install, the launch-close routine is repeated 30 times before a single uninstall is run. The OOB test provides you with standardized telemetry on your package to compare across Windows builds._

## Upload to Test Base

1. Update config.json.
   Before zip the package, in order to run the scripts, update the following variables in [config.json](./scripts/outofbox/config.json)

   ```json
   {
     "appProcessName": "<Name of the application process to be launched, e.g., Calculator>",
     "packageMSIXName": "<Name of the MSIX package file in bin folder, e.g., Calculator.msix>",
     "packageIdentityName": "<Name attribute value of Identity tag in the MSIX package manifest, e.g., Calculator>",
     "signingCertName": "<Name of the certificate to sign the MSIX package in bin folder, e. g., cert.pfx>",
     "signingCertPassword": "<Password of the certificate to sign the MSIX package, e. g., Password01!>"
   }
   ```

1. Zip the package.
   Under current location, run the following PowerShell command to zip a Test Base package.

   ```powershell
   Compress-Archive -Path .\* -DestinationPath package.zip
   ```

   The folder structure inside the zip folder that gets created is as follows:

   ```powershell
   |-- bin
   |   |-- Calculator.msix
   |   |-- cert.pfx
   |-- scripts
   |   |-- outofbox
   |   |   |-- close.ps1
   |   |   |-- config.json
   |   |   |-- install.ps1
   |   |   |-- launch.ps1
   |   |   |-- uninstall.ps1
   ```

1. Upload to Test Base service.
   Follow this [guide](https://docs.microsoft.com/en-us/microsoft-365/test-base/uploadapplication?view=o365-worldwide) to upload this zip package.  
   The script paths are as follows:
   - **Install script**: scripts/outofbox/install.ps1
   - **Launch script**: scripts/outofbox/launch.ps1
   - **Close script**: scripts/outofbox/close.ps1
   - **Uninstall script**: scripts/outofbox/uninstall.ps1
