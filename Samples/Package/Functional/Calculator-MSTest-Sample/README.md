# Calculator Functional Package (MSTest Test Cases)
## Calculator
Calculator is a sample app which is being tested. Click [here](../../../../Sample-App-Src/Calculator) for details of Calculator.

## MSTest Test Project
This package sample includes one functional test project: [CLITest](./Tests). Command-line interface Tests is a sample test project that runs and validates basic command line scenarios on **Calculator** application, using MSTest framework.

*A Functional test executes your uploaded test script(s) on your package. The scripts are run in the sequence you specified and a failure in a particular script will stop subsequent scripts from executing.*

### Prerequsites
To build the test cases, you need to install:
- [.NET SDK](https://dotnet.microsoft.com/download)

To be able to develop new test cases, what else you need:
- Microsoft Visual Studio 2017 or later

### Build
Enter *Tests* folder and run *build.ps1* in PowerShell to build, then find the binaries under *drop* folder.

## Upload to Test Base
1. Prepare the package binaries
   - Enter *Package* folder, create a *bin* folder and copy [calculator.msi](../../Out-of-Box/Calculator-OOB-Sample/bin) to *bin*.
   - Create a *TestBin* folder under *bin*, build CLITest and copy all the files under *drop* folder to *TestBin*.
1. Zip the package  
   Enter *Package* folder, run the following PowerShell command to zip a Test Base package. 
    ```
    Compress-Archive -Path .\* -DestinationPath package.zip
    ```  
   The folder structure inside the zip folder that gets created is as follows:  
    ```
    |-- bin
    |   |-- calculator.msi
    |   |-- TestBin
    |   |   |-- <test binaries>
    |-- scripts
    |   |-- functional
    |   |   |-- install-app.ps1
    |   |   |-- run-test.ps1
    |   |   |-- setup-test-env.ps1
    ```
2. Upload to Test Base service  
Follow this [guide](https://docs.microsoft.com/en-us/microsoft-365/test-base/uploadapplication?view=o365-worldwide) to upload this zip package.  
The order of the scripts are as follows:
    1. scripts/functional/setup-test-env.ps1
    1. scripts/functional/install-app.ps1
    1. scripts/functional/run-test.ps1
