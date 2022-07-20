# Test Base for Microsoft 365
[Test Base for Microsoft 365](https://www.microsoft.com/en-us/testbase) is an Azure service that facilitates data-driven testing of applications. Backed by the power of data and the cloud, it enables IT professionals to take advantage of intelligent testing from anywhere in the world. It will help you test your applications without the hassle, time commitment, and expenditure of setting up and maintaining complex test environments. Most importantly, it will give you access to pre-release Windows Updates on secure virtual machines (VMs) and world-class intelligence for your applications.

This repository contains various samples and utilities to [build a Test Base package](https://docs.microsoft.com/en-us/microsoft-365/test-base/buildpackage?view=o365-worldwide).

## Best Practices
Provide you with some useful samples of Test Base integration, which are best practices to use Test Base, such as
 - Construct Test Base scripts with your project
 - Build and upload test base package
 - Monitor the test results of Test Base

## Sample app source code
It contains the source code of the sample app. This app is a sample/test 
app to try out the functionality of Test Base.

## Sample List
Two types of samples are included in this repository: Package and SDK.
### Package Samples
We provide many package samples with different test types and different languages. Most of the samples use [Calculator](./Sample-App-Src/Calculator) as the test target.

#### Out of Box
An OOB test performs an install, launch, close, and uninstall of your application. After the install, the launch-close routine is repeated 30 times before a single uninstall is run. The OOB test provides you with standardized telemetry on your package to compare across Windows builds.

Two OOB samples are provided, click the links to find more details:
 - [Calculator-OOB-Sample](./Samples/Package/Out-of-Box/Calculator-OOB-Sample)
 - [StoreAPP-OOB-Sample](./Samples/Package/Out-of-Box/StoreAPP-OOB-Sample)

#### Functional
A Functional test executes your uploaded test script(s) on your package. The scripts are run in the sequence you specified and a failure in a particular script will stop subsequent scripts from executing.

 [Appium](https://github.com/appium/appium) is levaraged to do UI automation test. And [MSTest](https://docs.microsoft.com/en-us/dotnet/core/testing/unit-testing-with-mstest) is levaraged to do CLI test. Also C#, Java, Python are used in the samples.

Here is the list of current functional test samples, click the links to find more details:
- [Calculator-Appium-Charp-Sample](./Samples/Package/Functional/Calculator-Appium-Charp-Sample)
- [Calculator-Appium-Java-Sample](./Samples/Package/Functional/Calculator-Appium-Java-Sample)
- [Calculator-Appium-Python-pytest-Sample](./Samples/Package/Functional/Calculator-Appium-Python-pytest-Sample)
- [Calculator-Appium-Python-unittest-Sample](./Samples/Package/Functional/Calculator-Appium-Python-unittest-Sample)
- [Calculator-MSTest-Sample](./Samples/Package/Functional/Calculator-MSTest-Sample)

### SDK Samples
Test Base provides APIs/SDK to help you manage Test Base resources, get test results programmatically, and integrate them with our CI tools. SDK samples show how to use Test Base SDK in different ways.
- [Samples of how to use Python SDK](https://github.com/Azure-Samples/azure-samples-python-management/tree/main/samples/testbase)
## Utilities
Utilities contain tools and scripts to help integrate with CICD, build and verify the Test Base package.
## Issues and Feedback
To report an issue, visit [Issues](https://github.com/microsoft/testbase/issues) page.

To provide feedback, make feature proposals, or participate in polls, visit [Discussions](https://github.com/microsoft/testbase/discussions) page.


## Useful links
- [Test Base Blog](https://techcommunity.microsoft.com/t5/test-base-blog/bg-p/USL-Blog) - Get the latest news about Test Base
- [Test Base for Microsoft 365 documentation
](https://docs.microsoft.com/en-us/microsoft-365/test-base/?view=o365-worldwide) - Microsoft documentation on details of Test Base.
