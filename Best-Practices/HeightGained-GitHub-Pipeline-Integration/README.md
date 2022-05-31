## Simple console app to showcase using Test Base to test your applications
This sample demonstrates how to integrate your app with Test Base via GitHub CI/CD. You can learn from this sample:
- How to add test scripts for Test Base in your project
- How to zip your app and scripts to a Test Base package (zip)
- How to use Test Base Python SDK to upload package and check test results
- How to build GitHub actions to integrate with Test Base
### HeightGained
The app is a calculator to compute vertical gain based on 
grade % and horizontal distance traveled. It can do the math
in metric system or US customary units. This app is simply a sample/test 
app to try out the functionality of Test Base.

#### Usage
```
    HeightGained.exe gradeinPercent distance useMetricUnits
    gradeinPercent and distance should be numeric
    useMetricUnits should be 1 for using meters instead of miles and feet
```

### Scripts to test HeightGained in TestBase
PowerShell scripts under [./HeightGained/Scripts](./HeightGained/Scripts) folder are used for Out-of-Box (OOB) test. OOB test is a basic compact test in Test Base, you can refer to [Test Base docs](https://docs.microsoft.com/en-us/microsoft-365/test-base/buildpackage?view=o365-worldwide) for more details.

There're 4 scripts:
- Install script installs .NET runtime, which is a dependency of the app.
- Launch script launches the app and returns 0 if the execution was successful. 
- Close and uninstall scripts simply return 0.

### Zip the app and scripts to a Test Base package (zip)
There is a PowerShell script [./HeightGained/Utilities/compress.ps1](./HeightGained/Utilities/compress.ps1) that zips us the 4 scripts needed
for OOB test in test base along with the binaries for HeightGained app. The 
folder structure inside the zip folder that gets created is as follows.

```
+-- Scripts
|   install.ps1
|   launch.ps1
|   close.ps1
|   uninstall.ps1
|   <everything in the bin folder for the app including the main exe and references>
```

Since the PowerShell scripts assume the relative location of the binaries to execute, it is 
essential to be mindful of the structure inside the zip.

When onboarding to Test Base, you will pass in the relative path of the scripts (e.g.:
Launch Script Path: "Scripts/launch.ps1").
    
### Using Test Base API
There're 2 python scripts under [./HeightGained/Utilities](./HeightGained/Utilities) demonstrate Test Base API usage.
- upload_package.py shows using Test Base API to upload a package, return 0 if the package is uploaded successfully, return -1 otherwise.
- check_results.py shows how to list test summaries,
returns 0 if there was no test failure in the last 24 hours, and return -1 otherwise.

In order to run the python script, set the following environment variables. To get the client ID and secret,
follow the instructions in [register a new application using Azure portal](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal).
```
AZURE_TENANT_ID=<tenand id>
AZURE_CLIENT_ID=<appId from sp create-for-rbac>
AZURE_CLIENT_SECRET=<password from sp create-for-rbac>
AZURE_SUBSCRIPTION_ID=<subscription id>
RESOURCE_GROUP_NAME=<resource group name for test base account>
TESTBASE_ACCOUNT_NAME=<test base account name>

// The following are only for upload_package.py
APPLICATION_NAME=<application name in Test Base>
APPLICATION_VERSION=<application version in Test Base>
OSS_TO_TEST=<OS version to test, e.g., 'Windows 10 21H2, Windows 11 21H2'>
PACKAGE_FILE_PATH=<package file path, e.g., './HeightGained.zip'>
SCRIPT_PATH_INSTALL=<script path, should be 'Scripts/install.ps1'>
SCRIPT_PATH_LAUNCH=<script path, should be 'Scripts/launch.ps1'>
SCRIPT_PATH_CLOSE=<script path, should be 'Scripts/close.ps1'>
SCRIPT_PATH_UNINSTALL=<script path, should be 'Scripts/uninstall.ps1'>
```

For more info, visit [Test Base Blog](https://techcommunity.microsoft.com/t5/test-base-blog/test-base-for-microsoft-365-sdk-amp-apis-now-available/ba-p/2888698)
### Test Base Integration via GitHub CI/CD
2 workflows created under [/.github/workflows](/.github/workflows) to integrate with Test Base. They leverage the python scripts under [./HeightGained/Utilities](./HeightGained/Utilities).
- deploy-to-testbase.yml: Whenever there's a change on the app, this workflow will:
    - Build the app
    - Zip the package
    - Upload the package to Test Base and start test
- check-testbase-results.yml: Check if there's a failure in the last 24 hours.
