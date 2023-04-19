# Create Intune Package

### Prerequisites
#### How to get authentication token by using the azure CLI
1. Use winget to Install and manage updates for Azure CLI.
```
winget install -e --id Microsoft.AzureCLI
```

2. Begin signing in to azure by using Azure CLI to run the 'az login' command.
1. Generation your Azure AD access token by running the 'az account get-access-token' command.
1. For Azure RESTAPI, Add the  Azure AD token to header like 'Authorization: Bearer xxxxxxxxx'
1. Generation your MS Graph API access token by running the 'az account get-access-token --resource-type ms-graph' command.
1. For MS Graph API, Add the MS Graph API token to header like 'Authorization: Bearer xxxxxxxxx'
## Creating Package Flow
Create DraftPackage->Get DraftPackage Path->Upload intune file->Extract File-> Patch DraftPackage->GenerateFolders And Scripts->Create Package->Delete DraftPackage

## REST API
### DraftPackage - Create
Create or replace (overwrite/recreate, with potential downtime) a Test Base Draft Package.
#### HTTP Request
```
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/draftPackages/{draftPackageName}?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| draftPackageName | string | The resource name of the Test Base Drafte Package.This is a GUID-formatted string. |
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
In the request URL, provide the following query parameters with values.

| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
| Accept | application/json. |
#### Example
##### Request

```http
PUT https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0?api-version=2023-01-01-preview
```

##### Response

```http
{
  "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0",
  "name": "ACCA5D09-096E-4356-99E3-5F4DCB2E19D0",
  "type": "microsoft.testbase/testbaseaccounts/draftpackages",
  "systemData": {
    "createdBy": "<username>",
    "createdByType": "User",
    "createdAt": "2023-03-21T05:52:22.3699227Z",
    "lastModifiedBy": "<username>",
    "lastModifiedByType": "User",
    "lastModifiedAt": "2023-03-21T05:52:22.3699227Z"
  },
  "properties": {
    "lastModifiedTime": "2023-03-21T05:52:22.6469067Z",
    "draftPackagePath": "e54624e1-e6dc-4716-900c-eedbafda70d3/5f37f5a4-17cb-414a-b0c9-d817c6a49fb7/draftPackagePath",
    "workingPath": "e54624e1-e6dc-4716-900c-eedbafda70d3/5f37f5a4-17cb-414a-b0c9-d817c6a49fb7/workingPath",
    "sourceType": "Native",
    "useSample": false,
    "editPackage": false,
    "useAutofill": false,
    "provisioningState": "Succeeded"
  }
}
```

### DraftPackage - Get Draft Package Path
Gets draft package path and temp working path with SAS.
#### HTTP Request
```
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/draftPackages/{draftPackageName}/getPath?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| draftPackageName | string | The resource name of the Test Base Drafte Package.This is a GUID-formatted string. |
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
In the request URL, provide the following query parameters with values.

| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
| Accept | application/json. |
#### Example
##### Request

```http
POST https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0/getPath?api-version=2023-01-01-preview
```

##### Response

```http
{
    "baseUrl": "some URL",
    "draftPackagePath": "e54624e1-e6dc-4716-900c-eedbafda70d3/5f37f5a4-17cb-414a-b0c9-d817c6a49fb7/draftPackagePath",
    "workingPath": "e54624e1-e6dc-4716-900c-eedbafda70d3/5f37f5a4-17cb-414a-b0c9-d817c6a49fb7/workingPath",
    "sasToken": "sas Token",
    "expirationTime": "2023-03-15T03:54:33.1935911Z"
}
```
### DraftPackage - Extract File
Performs extracting file operation for a Test Base Draft Package.
#### HTTP Request
```
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/draftPackages/{draftPackageName}/extractFile?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| draftPackageName | string | The resource name of the Test Base Drafte Package.This is a GUID-formatted string. |
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
In the request URL, provide the following query parameters with values.

| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
| Accept | application/json. |
#### Example
##### Request

```http
POST https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0/extractFile?api-version=2023-01-01-preview

{
    "sourceFile": "bin/<intune file name>"
}
```

##### Response
```http
```

### DraftPackage - Generate Folders And Scripts
Generates folders and scripts.
#### HTTP Request
```
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/draftPackages/{draftPackageName}/generateFoldersAndScripts?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| draftPackageName | string | The resource name of the Test Base Drafte Package.This is a GUID-formatted string. |
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
In the request URL, provide the following query parameters with values.

| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
| Accept | application/json. |
#### Example
##### Request

```http
POST https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0/generateFoldersAndScripts?api-version=2023-01-01-preview
```

##### Response
```http
```

### DraftPackage - update draft package
Updates an existing Test Base Draft Package.
#### HTTP Request
```
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/draftPackages/{draftPackageName}?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| draftPackageName | string | The resource name of the Test Base Drafte Package.This is a GUID-formatted string. |
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
In the request URL, provide the following query parameters with values.

| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
| Accept | application/json. |
#### Request Body

| Name | Type | Description |
|:----------|:-----|:------------|
| properties.appFileName | string | The name of the app file. |
| properties.intuneMetadata.intuneApp | IntuneAppMetadataItem | a single Intune App, the information is from listIntuneApps. |
| properties.intuneMetadata.intuneAppDependencies | IntuneAppMetadataItem[] | The dependencies of the Intune App. The information from listIntuneDependencies. |
| properties.useAutofill | bool | Indicates whether user choose to enable script auto-fill. |
| properties.testTypes | string | OOB, functional or flow driven. Mapped to the data in 'tests' property. |
| properties.firstPartyApps | string | Specifies the list of first party applications to test along with user application. The information from getFirstPartyApps. |
| properties.targetOSList | TargetOSInfo[] | Specifies the target OSs of specific OS Update types. |
| properties.flightingRing | string | The flighting ring for feature update. |
| properties.tests | Test[] | The detailed test information. |
| properties.tabState | string | Specifies current state of tabs. |
#### Example
##### Request

```http
PATCH https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0?api-version=2023-01-01-preview

{
  "properties": {
    "sourceType": "IntuneWin",
    "appFileName": "setup.intunewin",
    "useSample": false,
    "applicationName": "Intune App Dependency",
    "version": "1111",
    "intuneMetadata": {
      "intuneApp": {
        "publisher": "TB-Admin",
        "description": "Test.intunewin",
        "owner": "",
        "createDate": "2022-10-12T07:22:07.0665657Z",
        "dependentAppCount": 1,
        "installCommand": "install testapp.exe",
        "uninstallCommand": "uninstall testapp.exe",
        "lastProcessed": 638149759454008000,
        "minimumSupportedOS": "Windows 10 2H20",
        "setupFile": "setup.exe"
      },
      "intuneAppDependencies": [
        {
          "createDate": "0001-01-01T00:00:00.0000000Z",
          "installCommand": "start-demo.exe",
          "uninstallCommand": "uninstall demo-intune-app.exe",
          "lastProcessed": 638149761279481300,
          "setupFile": "setup.exe",
          "appId": "fe6d7f55-627b-4b22-a6a7-587f07336535",
          "appName": "Demo Intune App",
          "status": "0"
        }
      ]
    },
    "useAutofill": false,
    
    "testTypes": [
      "OutOfBoxTest"
    ],
    "firstPartyApps": [],
    
    "targetOSList": [
      {
        "osUpdateType": "Security updates",
        "targetOSs": [
          "Windows 11 22H2"
        ]
      }
    ],
    "flightingRing": "",
    
    "packageTags": {},
    
    "tabState": {
      "currentTab": "ReviewAndCreateTab"
    }
  }
}

```
##### Response
```http
{
  "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0",
  "name": "ACCA5D09-096E-4356-99E3-5F4DCB2E19D0",
  "properties": {
    "applicationName": "Intune App Dependency",
    "version": "1111",
    "testTypes": [
      "OutOfBoxTest"
    ],
    "targetOSList": [
      {
        "osUpdateType": "Security updates",
        "targetOSs": [
          "Windows 11 22H2"
        ]
      }
    ],
    "lastModifiedTime": "2023-03-21T06:45:35.1716802Z",
    "flightingRing": "",
    "firstPartyApps": [],
    "tests": [
      {
        "testType": "OutOfBoxTest",
        "validationRunStatus": "Unknown",
        "isActive": true,
        "commands": [
          {
            "name": "install",
            "action": "Install",
            "contentType": "Path",
            "content": "scripts/outofbox/install.ps1",
            "runElevated": false,
            "restartAfter": true,
            "maxRunTime": 0,
            "runAsInteractive": false,
            "alwaysRun": false,
            "applyUpdateBefore": false,
            "preUpgrade": false,
            "postUpgrade": false,
            "install1PAppBefore": false
          },
          {
            "name": "launch",
            "action": "Launch",
            "contentType": "Path",
            "content": "scripts/outofbox/launch.ps1",
            "runElevated": false,
            "restartAfter": false,
            "maxRunTime": 0,
            "runAsInteractive": false,
            "alwaysRun": false,
            "applyUpdateBefore": false,
            "preUpgrade": false,
            "postUpgrade": false,
            "install1PAppBefore": false
          },
          {
            "name": "close",
            "action": "Close",
            "contentType": "Path",
            "content": "scripts/outofbox/close.ps1",
            "runElevated": false,
            "restartAfter": false,
            "maxRunTime": 0,
            "runAsInteractive": false,
            "alwaysRun": false,
            "applyUpdateBefore": false,
            "preUpgrade": false,
            "postUpgrade": false,
            "install1PAppBefore": false
          },
          {
            "name": "uninstall",
            "action": "Uninstall",
            "contentType": "Path",
            "content": "scripts/outofbox/uninstall.ps1",
            "runElevated": false,
            "restartAfter": false,
            "maxRunTime": 0,
            "runAsInteractive": false,
            "alwaysRun": false,
            "applyUpdateBefore": false,
            "preUpgrade": false,
            "postUpgrade": false,
            "install1PAppBefore": false
          }
        ]
      }
    ],
    "draftPackagePath": "e54624e1-e6dc-4716-900c-eedbafda70d3/5f37f5a4-17cb-414a-b0c9-d817c6a49fb7/draftPackagePath",
    "workingPath": "e54624e1-e6dc-4716-900c-eedbafda70d3/5f37f5a4-17cb-414a-b0c9-d817c6a49fb7/workingPath",
    "appFileName": "setup.intunewin",
    "sourceType": "IntuneWin",
    "useSample": false,
    "intuneMetadata": {
      "intuneApp": {
        "appName": "Intune App w/t Dependency",
        "appId": "dc5faa4c-6fb5-4e04-8d73-cff76b351576",
        "publisher": "TB-Admin",
        "description": "Test.intunewin",
        "owner": "",
        "createDate": "2022-10-12T07:22:07.0665657Z",
        "dependentAppCount": 1,
        "installCommand": "install testapp.exe",
        "uninstallCommand": "uninstall testapp.exe",
        "lastProcessed": 638149759454008000,
        "setupFile": "setup.exe",
        "minimumSupportedOS": "Windows 10 2H20",
        "status": "Uploading"
      },
      "intuneAppDependencies": [
        {
          "appName": "Demo Intune App",
          "appId": "fe6d7f55-627b-4b22-a6a7-587f07336535",
          "createDate": "0001-01-01T00:00:00.0000000Z",
          "dependentAppCount": 0,
          "installCommand": "start-demo.exe",
          "uninstallCommand": "uninstall demo-intune-app.exe",
          "lastProcessed": 638149761279481300,
          "setupFile": "setup.exe",
          "status": "Ready"
        }
      ]
    },
    "highlightedFiles": [
      {
        "path": "scripts/outofbox/install.ps1",
        "visited": false,
        "sections": [
          "Introduction",
          "Commands",
          "Verify"
        ]
      },
      {
        "path": "scripts/outofbox/launch.ps1",
        "visited": false,
        "sections": [
          "Introduction",
          "Commands",
          "Verify"
        ]
      },
      {
        "path": "scripts/outofbox/close.ps1",
        "visited": false,
        "sections": [
          "Introduction",
          "Commands",
          "Verify"
        ]
      },
      {
        "path": "scripts/outofbox/uninstall.ps1",
        "visited": false,
        "sections": [
          "Introduction",
          "Commands",
          "Verify"
        ]
      }
    ],
    "packageTags": {},
    "editPackage": false,
    "useAutofill": false,
    "tabState": {
      "currentTab": "ReviewAndCreateTab"
    }
  }
}

```

### Package - Create
Create or replace (overwrite/recreate, with potential downtime) a Test Base Package.
#### HTTP Request
```
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/packages/{packageName}?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| packageName | string | The resource name of the Test Base  Package. |
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
In the request URL, provide the following query parameters with values.

| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
| Accept | application/json. |
#### Request Body

| Name | Type | Description |
|:----------|:-----|:------------|
| location | string | The geo-location where the resource lives. |
| properties.applicationName | string | The name of the application. |
| properties.version | string | The version of the application. |
| properties.draftPackageId | string | the draft Package Id. This is a GUID-formatted string. |
#### Example
##### Request

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/packages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0?api-version=2023-01-01-preview

{
  "location": "global",
  "properties": {
    "applicationName": "setup",
    "version": "21.007.20099",
    "draftPackageId": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0"
  }
}
```

##### Response

```http
{
  "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0",
  "name": "ACCA5D09-096E-4356-99E3-5F4DCB2E19D0",
  "type": "microsoft.testbase/testbaseaccounts/packages",
  "location": "global",
  "systemData": {
    "createdBy": "<username>",
    "createdByType": "User",
    "createdAt": "2023-03-21T07:04:52.5358137Z",
    "lastModifiedBy": "<username>",
    "lastModifiedByType": "User",
    "lastModifiedAt": "2023-03-21T07:04:52.5358137Z"
  },
  "properties": {
    "applicationName": "setup",
    "version": "17171",
    "draftPackageId": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0",
    "provisioningState": "Accepted"
  }
}
```
### DraftPackage - Delete
Deletes a Test Base Draft Package.
#### HTTP Request
```
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/draftPackages/{draftPackageName}?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| draftPackageName | string | The resource name of the Test Base Drafte Package.This is a GUID-formatted string. |
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
In the request URL, provide the following query parameters with values.

| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
#### Example
##### Request

```http
DELETE https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/draftPackages/ACCA5D09-096E-4356-99E3-5F4DCB2E19D0?api-version=2023-01-01-preview
```

##### Response
Status code: 200

# Dependence services
listIntuneDependencies-> getRelationships
### Graph - List
List Intune Apps with graph api, selected one/multi intune app, put them to patch body.
#### HTTP Request
```
GET https://graph.microsoft.com/beta/deviceAppManagement/mobileApps?$filter=((microsoft.graph.managedApp/appAvailability%20eq%20null%20or%20microsoft.graph.managedApp/appAvailability%20eq%20%27lineOfBusiness%27%20or%20isAssigned%20eq%20true)%20and%20(isof(%27microsoft.graph.win32LobApp%27)))&$orderby=displayName&$top=20
```
#### Request headers
| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<graph token> Required. |
#### Example
##### Request

```http
GET https://graph.microsoft.com/beta/deviceAppManagement/mobileApps?$filter=((microsoft.graph.managedApp/appAvailability%20eq%20null%20or%20microsoft.graph.managedApp/appAvailability%20eq%20%27lineOfBusiness%27%20or%20isAssigned%20eq%20true)%20and%20(isof(%27microsoft.graph.win32LobApp%27)))&$orderby=displayName&$top=20
```

##### Response

```http
{
  "@odata.context": " https://graph.microsoft.com/beta /$metadata#deviceAppManagement/mobileApps",
  "@odata.count": 0,
  "value": [
    {
      "@odata.type": "#microsoft.graph.win32LobApp",
      "id": "dc5faa4c-6fb5-4e04-8d73-cff76b351576",
      "displayName": "Intune App w/t Dependency",
      "description": "Test.intunewin",
      "publisher": "TB-Admin",
      "largeIcon": null,
      "createdDateTime": "2022-10-12T07:22:07.0665657Z",
      "lastModifiedDateTime": "2023-03-01T06:18:27.8462087Z",
      "isFeatured": false,
      "privacyInformationUrl": null,
      "informationUrl": null,
      "owner": "",
      "developer": "",
      "notes": "",
      "uploadState": 1,
      "publishingState": "published",
      "isAssigned": false,
      "roleScopeTagIds": [],
      "dependentAppCount": 1,
      "supersedingAppCount": 0,
      "supersededAppCount": 0,
      "committedContentVersion": "1",
      "fileName": "Test.intunewin",
      "size": 2336,
      "installCommandLine": "install testapp.exe",
      "uninstallCommandLine": "uninstall testapp.exe",
      "runAs32Bit": false,
      "applicableArchitectures": "x64",
      "minimumFreeDiskSpaceInMB": null,
      "minimumMemoryInMB": null,
      "minimumNumberOfProcessors": null,
      "minimumCpuSpeedInMHz": null,
      "msiInformation": null,
      "setupFilePath": "Test.exe",
      "installLanguage": null,
      "minimumSupportedWindowsRelease": "2H20",
      "displayVersion": "",
      "allowAvailableUninstall": false,
      "minimumSupportedOperatingSystem": {
        "v8_0": false,
        "v8_1": false,
        "v10_0": false,
        "v10_1607": false,
        "v10_1703": false,
        "v10_1709": false,
        "v10_1803": false,
        "v10_1809": false,
        "v10_1903": false,
        "v10_1909": false,
        "v10_2004": false,
        "v10_2H20": true,
        "v10_21H1": false
      },
      "detectionRules": [
        {
          "@odata.type": "#microsoft.graph.win32LobAppProductCodeDetection",
          "productCode": "120",
          "productVersionOperator": "notConfigured",
          "productVersion": null
        }
      ],
      "requirementRules": [],
      "rules": [
        {
          "@odata.type": "#microsoft.graph.win32LobAppProductCodeRule",
          "ruleType": "detection",
          "productCode": "120",
          "productVersionOperator": "notConfigured",
          "productVersion": null
        }
      ],
      "installExperience": {
        "runAsAccount": "system",
        "requiresLogon": true,
        "installProgramVisibility": "hidden",
        "maximumRetries": 3,
        "retryIntervalInMinutes": 5,
        "maxRunTimeInMinutes": 60,
        "deviceRestartBehavior": "allow"
      },
      "returnCodes": [
        {
          "returnCode": 0,
          "type": "success"
        },
        {
          "returnCode": 1707,
          "type": "success"
        },
        {
          "returnCode": 3010,
          "type": "softReboot"
        },
        {
          "returnCode": 1641,
          "type": "hardReboot"
        },
        {
          "returnCode": 1618,
          "type": "retry"
        }
      ]
    }
  ]
}
```

### Graph - List Intune Dependencies
List Intune Dependencies with graph api.
#### HTTP Request
```
GET https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/${appId}/relationships
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| appId | string | The resource name of the Test Base Drafte Package.This is a GUID-formatted string. |
#### Request headers
| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<graph token> Required. |
#### Example
##### Request

```http
GET https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/dc5faa4c-6fb5-4e04-8d73-cff76b351576/relationships
```

##### Response

```http
{
  "@odata.context": "${this.baseUrl}/${this.intuneGraphBaseUri}/$metadata#deviceAppManagement/mobileApps('dc5faa4c-6fb5-4e04-8d73-cff76b351576')/relationships",
  "value": [
    {
      "@odata.type": "#microsoft.graph.mobileAppDependency",
      "id": "dc5faa4c-6fb5-4e04-8d73-cff76b351576_fe6d7f55-627b-4b22-a6a7-587f07336535",
      "targetId": "fe6d7f55-627b-4b22-a6a7-587f07336535",
      "targetDisplayName": "Demo Intune App",
      "targetDisplayVersion": "",
      "targetPublisher": "TB-Admin",
      "targetType": "child",
      "dependencyType": "autoInstall",
      "dependentAppCount": 0,
      "dependsOnAppCount": 0
    }
  ]
}
```

### TestBase - Get First Party Apps
Lists all first party applications currently available for test runs under a Test Base Account. 
#### HTTP Request
```
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/firstPartyApps?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |
#### Request headers
| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
#### Example
##### Request

```http
GET https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/firstPartyApps?api-version=2023-01-01-preview
```

##### Response

```http
{
  "value": [
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/firstPartyApps/firstPartyApp-8f7b5749-c6c5-67d2-88e9-01e8c947f2d7",
      "name": "firstPartyApp-8f7b5749-c6c5-67d2-88e9-01e8c947f2d7",
      "properties": {
        "mediaType": "Office",
        "ring": "Insiders",
        "channel": "Current Channel (Preview)",
        "architecture": "x86",
        "supportedProducts": [
          "Windows Insider Refresh (EKB)",
          "Windows Insider Refresh",
          "Windows Insider Program",
          "Windows 11 22H2",
          "Windows 11 21H2",
          "Windows 10 22H2",
          "Windows 10 21H2",
          "Windows 10 21H1",
          "Windows 10 20H2",
          "Windows 10 1909",
          "Windows 10 1809"
        ]
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/firstPartyApps/firstPartyApp-8f7b5749-fc11-c12c-88e9-01e8c947f2d7",
      "name": "firstPartyApp-8f7b5749-fc11-c12c-88e9-01e8c947f2d7",
      "properties": {
        "mediaType": "Office",
        "ring": "Insiders",
        "channel": "Current Channel (Preview)",
        "architecture": "x64",
        "supportedProducts": [
          "Windows Insider Refresh (EKB)",
          "Windows Insider Refresh",
          "Windows Insider Program",
          "Windows 11 22H2",
          "Windows 11 21H2",
          "Windows 10 22H2",
          "Windows 10 21H2",
          "Windows 10 21H1",
          "Windows 10 20H2",
          "Windows 10 1909",
          "Windows 10 1809"
        ]
      }
    }
  ]
}

```

### TestBase - Get Inplace Upgrade OSs
Lists all the available In-place Upgrade OSs to a package under a Test Base Account
#### HTTP Request
```
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/availableInplaceUpgradeOSs?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |

#### Request headers
| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
#### Example
##### Request

```http
GET https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableInplaceUpgradeOSs?api-version=2023-01-01-preview
```

##### Response

```http
{
  "value": [
    {
      "name": "Windows-10-21H1",
      "properties": {
        "sourceOsName": "Windows 10 21H1",
        "sourceOsReleases": [
          {
            "releaseName": "2022.12 B",
            "buildNumber": "19041",
            "buildRevision": "2364"
          },
          {
            "releaseName": "2022.09 B",
            "buildNumber": "19041",
            "buildRevision": "2006"
          },
          {
            "releaseName": "2022.08 B",
            "buildNumber": "19041",
            "buildRevision": "1889"
          },
          {
            "releaseName": "2022.07 B",
            "buildNumber": "19041",
            "buildRevision": "1826"
          },
          {
            "releaseName": "2022.06 B",
            "buildNumber": "19041",
            "buildRevision": "1766"
          },
          {
            "releaseName": "2022.05 B",
            "buildNumber": "19041",
            "buildRevision": "1706"
          },
          {
            "releaseName": "2022.04 B",
            "buildNumber": "19041",
            "buildRevision": "1645"
          },
          {
            "releaseName": "2022.03 B",
            "buildNumber": "19041",
            "buildRevision": "1586"
          },
          {
            "releaseName": "2022.02 B",
            "buildNumber": "19041",
            "buildRevision": "1526"
          },
          {
            "releaseName": "2022.01 B",
            "buildNumber": "19041",
            "buildRevision": "1466"
          },
          {
            "releaseName": "2021.12 B",
            "buildNumber": "19041",
            "buildRevision": "1415"
          },
          {
            "releaseName": "2021.11 B",
            "buildNumber": "19041",
            "buildRevision": "1348"
          },
          {
            "releaseName": "2021.09 B",
            "buildNumber": "19041",
            "buildRevision": "1237"
          },
          {
            "releaseName": "2021.06 B",
            "buildNumber": "19041",
            "buildRevision": "1052"
          },
          {
            "releaseName": "2021.05 B",
            "buildNumber": "19041",
            "buildRevision": "985"
          }
        ],
        "supportedTargetOsNameList": [
          "Windows 11 22H2"
        ]
      }
    },
    {
      "name": "Windows-10-20H2",
      "properties": {
        "sourceOsName": "Windows 10 20H2",
        "sourceOsReleases": [
          {
            "releaseName": "2023.01 B",
            "buildNumber": "19041",
            "buildRevision": "2486"
          },
          {
            "releaseName": "2022.12 B",
            "buildNumber": "19041",
            "buildRevision": "2364"
          },
          {
            "releaseName": "2022.09 B",
            "buildNumber": "19041",
            "buildRevision": "2006"
          },
          {
            "releaseName": "2022.08 B",
            "buildNumber": "19041",
            "buildRevision": "1889"
          },
          {
            "releaseName": "2022.07 B",
            "buildNumber": "19041",
            "buildRevision": "1826"
          },
          {
            "releaseName": "2022.06 B",
            "buildNumber": "19041",
            "buildRevision": "1766"
          },
          {
            "releaseName": "2022.05 B",
            "buildNumber": "19041",
            "buildRevision": "1706"
          },
          {
            "releaseName": "2022.04 B",
            "buildNumber": "19041",
            "buildRevision": "1645"
          },
          {
            "releaseName": "2022.03 B",
            "buildNumber": "19041",
            "buildRevision": "1586"
          },
          {
            "releaseName": "2022.02 B",
            "buildNumber": "19041",
            "buildRevision": "1526"
          },
          {
            "releaseName": "2022.01 B",
            "buildNumber": "19041",
            "buildRevision": "1466"
          },
          {
            "releaseName": "2021.12 B",
            "buildNumber": "19041",
            "buildRevision": "1415"
          },
          {
            "releaseName": "2021.11 B",
            "buildNumber": "19041",
            "buildRevision": "1348"
          },
          {
            "releaseName": "2021.09 B",
            "buildNumber": "19041",
            "buildRevision": "1220"
          },
          {
            "releaseName": "2021.06 B",
            "buildNumber": "19041",
            "buildRevision": "1052"
          },
          {
            "releaseName": "2021.05 B",
            "buildNumber": "19041",
            "buildRevision": "985"
          }
        ],
        "supportedTargetOsNameList": [
          "Windows 11 22H2",
          "Windows 10 21H2"
        ]
      }
    },
    {
      "name": "Windows-10-22H2",
      "properties": {
        "sourceOsName": "Windows 10 22H2",
        "sourceOsReleases": [
          {
            "releaseName": "2023.01 B",
            "buildNumber": "19041",
            "buildRevision": "2486"
          },
          {
            "releaseName": "2022.12 B",
            "buildNumber": "19041",
            "buildRevision": "2364"
          },
          {
            "releaseName": "2022.10 B",
            "buildNumber": "19041",
            "buildRevision": "2130"
          }
        ],
        "supportedTargetOsNameList": [
          "Windows 11 22H2"
        ]
      }
    }
  ]
}
```

### TestBase - Get Available FeatureUpdate Target Products
Lists all the available OSs to run a package under a Test Base Account.
#### HTTP Request
```
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/featureUpdateSupportedOses?api-version=2023-01-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |

#### Request headers
| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
#### Example
##### Request

```http
GET https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/featureUpdateSupportedOses?api-version=2023-01-01-preview
```

##### Response

```http
{
  "value": [
    {
      "properties": {
        "osId": "2091604052",
        "osName": "Windows 11 22H2",
        "displayText": "Windows 11 22H2 (Insider Beta Channel - Feature Off)",
        "version": "WindowsSunValley",
        "insiderChannel": "Insider Beta Channel - Feature Off",
        "startTime": "2022-10-27T00:00:00.0000000Z",
        "state": "Active",
        "baselineProducts": [
          "Windows 11 21H2",
          "Windows 10 21H2"
        ]
      }
    },
    {
      "properties": {
        "osId": "1227246100",
        "osName": "Windows 11 22H2",
        "displayText": "Windows 11 22H2 (Insider Beta Channel - Feature On)",
        "version": "WindowsSunValley",
        "insiderChannel": "Insider Beta Channel - Feature On",
        "startTime": "2022-10-27T00:00:00.0000000Z",
        "state": "Active",
        "baselineProducts": [
          "Windows 11 21H2",
          "Windows 10 21H2"
        ]
      }
    },
    {
      "properties": {
        "osId": "1891741446",
        "osName": "Windows 11 22H2",
        "displayText": "Windows 11 22H2 (Insider Beta Channel, RTM)",
        "version": "WindowsSunValley",
        "insiderChannel": "Insider Beta Channel",
        "startTime": "0001-01-01T00:00:00.0000000Z",
        "state": "Active",
        "baselineProducts": [
          "Windows 10 21H2",
          "Windows 11 21H2"
        ]
      }
    }
  ]
}
```

### TestBase - Get Available OSVersions For SecurityUpdate
Gets an available OS to run a package under a Test Base Account.
#### HTTP Request
```
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/availableOSs?api-version=2023-01-01-preview&osUpdateType=SecurityUpdate
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| resourceGroupName | string | The name of the resource group that contains the resource. |
| subscriptionId | string | The Azure subscription ID. This is a GUID-formatted string. |
| testBaseAccountName | string | The resource name of the Test Base Account. |
| api-version | string | The API version to be used with the HTTP request.. |

#### Request headers
| Header | Description |
|:----------|:------------|
| Authorization |  Bearer \<token> Required. |
#### Example
##### Request

```http
GET https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs?api-version=2023-01-01-preview&osUpdateType=SecurityUpdate
```

##### Response

```http
{
  "value": [
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2022---Server-Core-WindowsUpdate",
      "name": "Windows-Server-2022---Server-Core-WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2022 - Server Core",
        "osName": "Windows Server 2022 - Server Core",
        "osVersion": "WindowsServer2022",
        "osPlatform": "VHD_Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2022-WindowsUpdate",
      "name": "Windows-Server-2022-WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2022",
        "osName": "Windows Server 2022",
        "osVersion": "WindowsServer2022",
        "osPlatform": "VHD_Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2019---Server-Core-WindowsUpdate",
      "name": "Windows-Server-2019---Server-Core-WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2019 - Server Core",
        "osName": "Windows Server 2019 - Server Core",
        "osVersion": "WindowsServer2019",
        "osPlatform": "VHD_Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2019-WindowsUpdate",
      "name": "Windows-Server-2019-WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2019",
        "osName": "Windows Server 2019",
        "osVersion": "WindowsServer2019",
        "osPlatform": "VHD_Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2016---Server-Core-WindowsUpdate",
      "name": "Windows-Server-2016---Server-Core-WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2016 - Server Core",
        "osName": "Windows Server 2016 - Server Core",
        "osVersion": "WindowsServer2016",
        "osPlatform": "VHD_Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2016-WindowsUpdate",
      "name": "Windows-Server-2016-WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2016",
        "osName": "Windows Server 2016",
        "osVersion": "WindowsServer2016",
        "osPlatform": "VHD_Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-11-22H2-WindowsUpdate",
      "name": "Windows-11-22H2-WindowsUpdate",
      "properties": {
        "osId": "Windows 11 22H2",
        "osName": "Windows 11 22H2",
        "osVersion": "WindowsSunValley",
        "osPlatform": "VHD_Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-11-21H2-WindowsUpdate",
      "name": "Windows-11-21H2-WindowsUpdate",
      "properties": {
        "osId": "Windows 11 21H2",
        "osName": "Windows 11 21H2",
        "osVersion": "WindowsSunValley",
        "osPlatform": "VHD_Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-10-22H2-WindowsUpdate",
      "name": "Windows-10-22H2-WindowsUpdate",
      "properties": {
        "osId": "Windows 10 22H2",
        "osName": "Windows 10 22H2",
        "osVersion": "Windows10",
        "osPlatform": "VHD_Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-10-21H2-WindowsUpdate",
      "name": "Windows-10-21H2-WindowsUpdate",
      "properties": {
        "osId": "Windows 10 21H2",
        "osName": "Windows 10 21H2",
        "osVersion": "Windows10",
        "osPlatform": "VHD_Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-10-20H2-WindowsUpdate",
      "name": "Windows-10-20H2-WindowsUpdate",
      "properties": {
        "osId": "Windows 10 20H2",
        "osName": "Windows 10 20H2",
        "osVersion": "Windows10",
        "osPlatform": "VHD_Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/All-Future-OS-Updates-WindowsUpdate",
      "name": "All-Future-OS-Updates-WindowsUpdate",
      "properties": {
        "osId": "All Future OS Updates",
        "osName": "All Future OS Updates",
        "osVersion": "Windows10",
        "osPlatform": "Unknown",
        "osUpdateType": "WindowsUpdate"
      }
    }
  ]
}
```
