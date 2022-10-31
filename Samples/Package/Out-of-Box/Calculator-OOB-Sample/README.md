# Calculator Out of Box Package
## Calculator
Click [here](../../../../Sample-App-Src/Calculator) for details.

## Out of Box Test
The Out-of-Box (OOB) test is a basic compatibility test method in Test Base.

*An OOB test performs an install, launch, close, and uninstall of your application. After the install, the launch-close routine is repeated 30 times before a single uninstall is run. The OOB test provides you with standardized telemetry on your package to compare across Windows builds.*
## Upload to Test Base
1. Update config.json
Before zip the package, in order to run the scripts, update the following variables in [config.json](./scripts/config.json)
```
{
    "appName": "<application name,e.g.,calculator.exe>",
    "appProcessName": "<application process name,e.g.,calculator>",
    "msiName": "<msi package name,e.g.,calculator.msi>",
    "installedPath": "<installed path,e.g.,C:\\Program Files (x86)\\calculator>"
}
```
2. Zip the package  
   Under current location, run the following PowerShell command to zip a Test Base package. 
    ```
    Compress-Archive -Path .\* -DestinationPath package.zip
    ```  
   The folder structure inside the zip folder that gets created is as follows:  
    ```
    |-- bin
    |   |-- calculator.msi
    |-- scripts
    |   |-- outofbox
    |   |   |-- install.ps1
    |   |   |-- launch.ps1
    |   |   |-- close.ps1
    |   |   |-- uninstall.ps1
    |   |   |-- config.json
    ```
3. Upload to Test Base service  
Follow this [guide](https://docs.microsoft.com/en-us/microsoft-365/test-base/uploadapplication?view=o365-worldwide) to upload this zip package.  
The script paths are as follows:
    - **Install script**: scripts/outofbox/install.ps1
    - **Launch script**: scripts/outofbox/launch.ps1
    - **Close script**: scripts/outofbox/close.ps1
    - **Uninstall script**: scripts/outofbox/uninstall.ps1
