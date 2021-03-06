# Store App Out of Box Package
## Microsoft To Do: Lists, Tasks & Reminders
This package sample is using **Microsoft To Do** as the test target. **Microsoft To Do** is an App in **Microsoft Store**. Click [here](https://apps.microsoft.com/store/detail/microsoft-to-do-lists-tasks-reminders/9NBLGGH5R558) for details of **Microsoft To Do**.

## Out of Box Test
The Out-of-Box (OOB) test is a basic compatibility test method in Test Base.

*An OOB test performs an install, launch, close, and uninstall of your application. After the install, the launch-close routine is repeated 30 times before a single uninstall is run. The OOB test provides you with standardized telemetry on your package to compare across Windows builds.*
## Upload to Test Base
1. Update config.ps1
Before zip the package, in order to run the scripts, update the following variables in [config.ps1](./scripts/config.ps1)
```
$global:AppStoreURL = <application store url,e.g.,https://www.microsoft.com/en-us/p/microsoft-to-do-lists-tasks-reminders/9nblggh5r558>
$global:AppId = <PackageFamilyName!App,e.g.,Microsoft.Todos_8wekyb3d8bbwe!App>
$global:AppProcessName = <application process name,e.g.,Todo>
```
2. Zip the package
   Under current location, run the following PowerShell command to zip a Test Base package.
    ```
    Compress-Archive -Path .\* -DestinationPath package.zip
    ```
   The folder structure inside the zip folder that gets created is as follows:
    ```
    |-- scripts
    |   |-- outofbox
    |   |   |-- config.ps1
    |   |   |-- install.ps1
    |   |   |-- launch.ps1
    |   |   |-- close.ps1
    |   |   |-- uninstall.ps1
    ```
3. Upload to Test Base service
Follow this [guide](https://docs.microsoft.com/en-us/microsoft-365/test-base/uploadapplication?view=o365-worldwide) to upload this zip package.
The script paths are as follows:
    - **Config script**: scripts/outofbox/config.ps1
    - **Install script**: scripts/outofbox/install.ps1
    - **Launch script**: scripts/outofbox/launch.ps1
    - **Close script**: scripts/outofbox/close.ps1
    - **Uninstall script**: scripts/outofbox/uninstall.ps1
