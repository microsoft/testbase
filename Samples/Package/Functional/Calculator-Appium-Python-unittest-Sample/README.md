# Calculator Functional Package (Appium Python Test Cases)
## Calculator
Calculator is a sample app which is being tested. Click [here](../../../../Sample-App-Src/Calculator) for details of Calculator.

## Appium Test Project
This package sample includes one functional test Script: [CalculatorTest.py](./Tests). CalculatorTest.py is a python functional test script based on the '**unittest**' Test Framework to run and validate basic UI scenarios on **Calculator** application. It highlights the following basic interactions to demonstrate how UI testing using [Windows Application Driver](https://github.com/Microsoft/WinAppDriver).
- Creating a modern UWP app session
- Finding element using name
- Finding element using XPath
- Sending click action to an element
- Retrieving element value

*A Functional test executes your uploaded test script(s) on your package. The scripts are run in the sequence you specified and a failure in a particular script will stop subsequent scripts from executing.*

### Prerequsites
To be able to develop new test cases, what else you need:
- Windows 10 PC with the latest Windows 10 version (Version 1809 or later)

To run python scripts, you need to install:
- [Python](https://www.python.org/downloads/)

To run test cases, following the guide to [install and run Windows Application Driver](https://github.com/microsoft/WinAppDriver/blob/master/README.md#installing-and-running-windows-application-driver).

## Upload to Test Base
1. Prepare the package binaries
   - Enter *Package* folder, create a *bin* folder and copy [calculator.msi](../../Out-of-Box/Calculator-OOB-Sample/bin) to *bin*.
   - Create a *TestBin* folder under *bin*, copy *Tests* folder and its content to *TestBin*.
2. Zip the package  
   Enter *Package* folder, run the following PowerShell command to zip a Test Base package. 
    ```
    Compress-Archive -Path .\* -DestinationPath package.zip
    ```  
   The folder structure inside the zip folder that gets created is as follows:  
    ```
    |-- bin
    |   |-- calculator.msi
    |   |-- TestBin
    |   |   |-- Tests
    |   |   |   |-- CalculatorTest.py
    |-- scripts
    |   |-- functional
    |   |   |-- install-app.ps1
    |   |   |-- run-test.ps1
    |   |   |-- setup-test-env.ps1
    ```
3. Upload to Test Base service  
Follow this [guide](https://docs.microsoft.com/en-us/microsoft-365/test-base/uploadapplication?view=o365-worldwide) to upload this zip package.  
The order of the scripts are as follows:
    1. scripts/functional/setup-test-env.ps1
    1. scripts/functional/install-app.ps1
    1. scripts/functional/run-test.ps1
