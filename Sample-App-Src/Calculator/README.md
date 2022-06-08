# Calculator
The app is a calculator with two types: with UI and without UI. It is simply a sample/test app to try out the functionality of Test Base.

## Prerequisites
Make sure you install the softwares below to build.
- [.NET SDK](https://dotnet.microsoft.com/download)
- [Node.js](https://nodejs.org/en/)
- [WiX Toolset](https://github.com/wixtoolset/wix3/releases)
After installation, add path of wix toolset (e.g, _C:\Program Files (x86)\WiX Toolset v3.14\bin_) to system variables

## Build
Run _build.ps1_ in PowerShell to build, then find the msi under **windows_installer** folder.
After intalling the msi, you will find the calculator under _C:\Program Files (x86)\Calculator_.

## Usage
Calculator is a simple calculator with UI.

CalculatorCLI is a simple command line calculator.
```
    CalculatorCLI.exe 2+2
    CalculatorCLI.exe 88/11
    CalculatorCLI.exe 8*2
```
