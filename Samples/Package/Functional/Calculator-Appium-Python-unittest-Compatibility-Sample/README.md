# Calculator Compatibility Test Package (Appium Python unittest Test Cases)
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

### Compatibility test cases
It is used to test your app's compatibility with Windows. For example:
- Create new desktop and launch it from different desktop
- Search App by Windows Search
- Max/Min your app
- Pin/Unpin your app to Start/TaskBar
- Open/Close your app from TaskBar

### Take ScreentShots
The example cases also implements how to **take screenshots** during testing.You can add the follow code where you want to take a screenshot in your cases(The path is designed by yourself):
```
   self.driver.get_screenshot_as_file(self._testMethodName +'.png')
```
After completing the test.You will get the ScreentShot files under your target filefolder and here is the example screenshot from our example test case:
![searchCalculator](.\test_searchCalculator.png)

### Prerequsites
To run python scripts, you need to install:
- [Python](https://www.python.org/downloads/)

To be able to develop new test cases, what else you need:
- Windows 10 PC with the latest Windows 10 version (Version 1809 or later)

To run test cases, following the guide to [install and run Windows Application Driver](https://github.com/microsoft/WinAppDriver/blob/master/README.md#installing-and-running-windows-application-driver).

To run test cases, You need to uninstall the calculator application that comes with your system first.

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
