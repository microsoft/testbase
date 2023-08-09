# Create ARM64 Package

### Prerequisites
#### How to get authentication token by using the azure CLI
1. Use winget to Install and manage updates for Azure CLI.
```
winget install -e --id Microsoft.AzureCLI
```

2. Begin signing in to azure by using Azure CLI to run the 'az login' command.
1. Generation your Azure AD access token by running the 'az account get-access-token' command.
1. For Azure RESTAPI, Add the  Azure AD token to header like 'Authorization: Bearer xxxxxxxxx'

## Creating Package Flow
Get Download URL->Upload package zip->Create/Updata package

## REST API
### TestBase - Get Available OSVersions For SecurityUpdate
Gets an available OS to run a package under a Test Base Account. set the value  to request body [properties.targetOSList] for create/update package.
#### HTTP Request
```
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/availableOSs?api-version=2023-05-15-preview&osUpdateType=SecurityUpdate
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
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2022---Server-Core_WindowsUpdate",
      "name": "Windows-Server-2022---Server-Core_WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2022 - Server Core",
        "osName": "Windows Server 2022 - Server Core",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsServer2022",
        "osPlatform": "Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2022_WindowsUpdate",
      "name": "Windows-Server-2022_WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2022",
        "osName": "Windows Server 2022",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsServer2022",
        "osPlatform": "Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2019---Server-Core_WindowsUpdate",
      "name": "Windows-Server-2019---Server-Core_WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2019 - Server Core",
        "osName": "Windows Server 2019 - Server Core",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsServer2019",
        "osPlatform": "Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2019_WindowsUpdate",
      "name": "Windows-Server-2019_WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2019",
        "osName": "Windows Server 2019",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsServer2019",
        "osPlatform": "Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2016---Server-Core_WindowsUpdate",
      "name": "Windows-Server-2016---Server-Core_WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2016 - Server Core",
        "osName": "Windows Server 2016 - Server Core",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsServer2016",
        "osPlatform": "Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-Server-2016_WindowsUpdate",
      "name": "Windows-Server-2016_WindowsUpdate",
      "properties": {
        "osId": "Windows Server 2016",
        "osName": "Windows Server 2016",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsServer2016",
        "osPlatform": "Server",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-11-22H2_WindowsUpdate_96d208e0-9af7-4e41-ac77-00d182b46fc2",
      "name": "Windows-11-22H2_WindowsUpdate_96d208e0-9af7-4e41-ac77-00d182b46fc2",
      "properties": {
        "osId": "Windows 11 22H2_96d208e0-9af7-4e41-ac77-00d182b46fc2",
        "osName": "Windows 11 22H2",
        "osArchitecture": "arm64",
        "osLanguage": "en-us",
        "osVersion": "WindowsSunValley",
        "osPlatform": "Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-11-22H2_WindowsUpdate",
      "name": "Windows-11-22H2_WindowsUpdate",
      "properties": {
        "osId": "Windows 11 22H2",
        "osName": "Windows 11 22H2",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsSunValley",
        "osPlatform": "Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-11-21H2_WindowsUpdate_28b37b48-9add-42c3-b32e-58bea1cce22d",
      "name": "Windows-11-21H2_WindowsUpdate_28b37b48-9add-42c3-b32e-58bea1cce22d",
      "properties": {
        "osId": "Windows 11 21H2_28b37b48-9add-42c3-b32e-58bea1cce22d",
        "osName": "Windows 11 21H2",
        "osArchitecture": "arm64",
        "osLanguage": "en-us",
        "osVersion": "WindowsSunValley",
        "osPlatform": "Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-11-21H2_WindowsUpdate",
      "name": "Windows-11-21H2_WindowsUpdate",
      "properties": {
        "osId": "Windows 11 21H2",
        "osName": "Windows 11 21H2",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "WindowsSunValley",
        "osPlatform": "Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-10-22H2_WindowsUpdate",
      "name": "Windows-10-22H2_WindowsUpdate",
      "properties": {
        "osId": "Windows 10 22H2",
        "osName": "Windows 10 22H2",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "Windows10",
        "osPlatform": "Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/Windows-10-21H2_WindowsUpdate",
      "name": "Windows-10-21H2_WindowsUpdate",
      "properties": {
        "osId": "Windows 10 21H2",
        "osName": "Windows 10 21H2",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "Windows10",
        "osPlatform": "Client",
        "osUpdateType": "WindowsUpdate"
      }
    },
    {
      "id": "/subscriptions/476f61a4-952c-422a-b4db-568a828f35df/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/availableOSs/All-Future-OS-Updates_WindowsUpdate",
      "name": "All-Future-OS-Updates_WindowsUpdate",
      "properties": {
        "osId": "All Future OS Updates",
        "osName": "All Future OS Updates",
        "osArchitecture": "x64",
        "osLanguage": "en-us",
        "osVersion": "Windows10",
        "osPlatform": "Unknown",
        "osUpdateType": "WindowsUpdate"
      }
    }
  ]
}
```

### Packages - Get Download URL
Gets the download URL of a package.
#### HTTP Request
```
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/packages/{packageName}/getDownloadUrl?api-version=2022-04-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| packageName | string | The resource name of the Test Base Package. |
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
POST https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/contoso-package2/getDownloadUrl?api-version=2022-04-01-preview
```

##### Response

```http
{
  "downloadUrl": "some URL",
  "expirationTime": "2021-01-10T06:00:00Z"
}
```

### Packages - Create
Create or replace (overwrite/recreate, with potential downtime) a Test Base Package.
#### HTTP Request
```
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/packages/{packageName}?api-version=2022-04-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| packageName | string | The resource name of the Test Base Package. |
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
| properties.applicationName | string | Application name. |
| properties.blobPath | string | The file path of the package. |
| properties.flightingRing | string | The flighting ring for feature update. |
| properties.targetOSList | TargetOSInfo[] | Specifies the target OSs of specific OS Update types. |
| properties.tests | Test[] | The detailed test information. |
| properties.version | string | Application version. |
| tags | object | The tags of the resource. |
#### Example
##### Request

```http
PUT https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/contoso-package2?api-version=2022-04-01-preview

{
  "location": "global",
  "properties": {
    "applicationName": "",
    "version": "",
    "blobPath": "",
    "flightingRing": "",
    "targetOSList": [
      {
        "targetOSs": [
          "Windows 11 22H2_96d208e0-9af7-4e41-ac77-00d182b46fc2"
        ],
        "osUpdateType": "Security updates"
      }
    ],
    "tests": [
      {
        "commands": [
          {
            "action": "Install",
            "name": "install",
            "content": "scripts/outofbox/install.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path",
            "restartAfter": true
          },
          {
            "action": "Launch",
            "name": "launch",
            "content": "scripts/outofbox/launch.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path"
          },
          {
            "action": "Close",
            "name": "close",
            "content": "scripts/outofbox/close.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path"
          },
          {
            "action": "Uninstall",
            "name": "uninstall",
            "content": "scripts/outofbox/uninstall.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path"
          }
        ],
        "testType": "OutOfBoxTest",
        "isActive": true
      }
    ]
  },
  "tags": {
  }
}

```
##### Response
```
{
  "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/contoso-package2",
  "name": "contoso-package2",
  "type": "Microsoft.TestBase/testBaseAccounts/packages",
  "location": "westus",
  "tags": {},
  "properties": {
    "provisioningState": "Succeeded",
    "applicationName": "contoso-package2",
    "version": "1.0.0",
    "testTypes": [
      "OutOfBoxTest"
    ],
    "targetOSList": [
      {
        "osUpdateType": "Security updates",
        "targetOSs": [
          "Windows 10 2004",
          "Windows 10 1903"
        ]
      }
    ],
    "packageStatus": "Ready",
    "lastModifiedTime": "2020-12-28T17:30:00Z",
    "flightingRing": "Insider Beta Channel",
    "isEnabled": true,
    "blobPath": "storageAccountPath/package.zip",
    "validationResults": [
      {
        "validationName": "Syntax Validation",
        "isValid": true
      },
      {
        "validationName": "Package Run Validation",
        "isValid": true
      }
    ],
    "tests": [
      {
        "testType": "OutOfBoxTest",
        "validationRunStatus": "Passed",
        "validationResultId": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/contoso-package2/testResults/TestResult-51d71a5f-e012-4192-88f7-bd12e0bac2b0",
        "isActive": true,
        "commands": [
          {
            "name": "Install",
            "action": "Install",
            "contentType": "Path",
            "content": "app/scripts/install/job.ps1",
            "runElevated": true,
            "restartAfter": true,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": true,
            "applyUpdateBefore": false
          },
          {
            "name": "Launch",
            "action": "Launch",
            "contentType": "Path",
            "content": "app/scripts/launch/job.ps1",
            "runElevated": true,
            "restartAfter": false,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": false,
            "applyUpdateBefore": true
          },
          {
            "name": "Close",
            "action": "Close",
            "contentType": "Path",
            "content": "app/scripts/close/job.ps1",
            "runElevated": true,
            "restartAfter": false,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": false,
            "applyUpdateBefore": false
          },
          {
            "name": "Uninstall",
            "action": "Uninstall",
            "contentType": "Path",
            "content": "app/scripts/uninstall/job.ps1",
            "runElevated": true,
            "restartAfter": false,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": true,
            "applyUpdateBefore": false
          }
        ]
      }
    ]
  }
}
```

### Packages - Update
Update an existing Test Base Package.
#### HTTP Request
```
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/{testBaseAccountName}/packages/{packageName}?api-version=2022-04-01-preview
```
#### Request parameters
In the request URL, provide the following query parameters with values.

| Parameter | Type | Description |
|:----------|:-----|:------------|
| packageName | string | The resource name of the Test Base Package. |
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
| properties.applicationName | string | Application name. |
| properties.blobPath | string | The file path of the package. |
| properties.flightingRing | string | The flighting ring for feature update. |
| properties.targetOSList | TargetOSInfo[] | Specifies the target OSs of specific OS Update types. |
| properties.tests | Test[] | The detailed test information. |
| properties.version | string | Application version. |
| tags | object | The tags of the resource. |
#### Example
##### Request

```http
PATCH https://management.azure.com/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/contoso-package2?api-version=2022-04-01-preview

{
  "location": "global",
  "properties": {
    "applicationName": "",
    "version": "",
    "blobPath": "",
    "flightingRing": "",
    "targetOSList": [
      {
        "targetOSs": [
          "Windows 11 22H2_96d208e0-9af7-4e41-ac77-00d182b46fc2"
        ],
        "osUpdateType": "Security updates"
      }
    ],
    "tests": [
      {
        "commands": [
          {
            "action": "Install",
            "name": "install",
            "content": "scripts/outofbox/install.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path",
            "restartAfter": true
          },
          {
            "action": "Launch",
            "name": "launch",
            "content": "scripts/outofbox/launch.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path"
          },
          {
            "action": "Close",
            "name": "close",
            "content": "scripts/outofbox/close.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path"
          },
          {
            "action": "Uninstall",
            "name": "uninstall",
            "content": "scripts/outofbox/uninstall.ps1",
            "applyUpdateBefore": false,
            "contentType": "Path"
          }
        ],
        "testType": "OutOfBoxTest",
        "isActive": true
      }
    ]
  },
  "tags": {
  }
}

```

##### Response
```
{
  "id": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/contoso-package2",
  "name": "contoso-package2",
  "type": "Microsoft.TestBase/testBaseAccounts/packages",
  "location": "westus",
  "tags": {},
  "properties": {
    "provisioningState": "Succeeded",
    "applicationName": "contoso-package2",
    "version": "1.0.0",
    "testTypes": [
      "OutOfBoxTest"
    ],
    "targetOSList": [
      {
        "osUpdateType": "Security updates",
        "targetOSs": [
          "Windows 11 22H2_96d208e0-9af7-4e41-ac77-00d182b46fc2"
        ]
      }
    ],
    "packageStatus": "Ready",
    "lastModifiedTime": "2020-12-28T17:30:00Z",
    "flightingRing": "Insider Beta Channel",
    "isEnabled": true,
    "blobPath": "storageAccountPath/package.zip",
    "validationResults": [
      {
        "validationName": "Syntax Validation",
        "isValid": true
      },
      {
        "validationName": "Package Run Validation",
        "isValid": true
      }
    ],
    "tests": [
      {
        "testType": "OutOfBoxTest",
        "validationRunStatus": "Passed",
        "validationResultId": "/subscriptions/subscription-id/resourceGroups/contoso-rg1/providers/Microsoft.TestBase/testBaseAccounts/contoso-testBaseAccount1/packages/contoso-package2/testResults/TestResult-51d71a5f-e012-4192-88f7-bd12e0bac2b0",
        "isActive": true,
        "commands": [
          {
            "name": "Install",
            "action": "Install",
            "contentType": "Path",
            "content": "app/scripts/install/job.ps1",
            "runElevated": true,
            "restartAfter": true,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": true,
            "applyUpdateBefore": false
          },
          {
            "name": "Launch",
            "action": "Launch",
            "contentType": "Path",
            "content": "app/scripts/launch/job.ps1",
            "runElevated": true,
            "restartAfter": false,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": false,
            "applyUpdateBefore": true
          },
          {
            "name": "Close",
            "action": "Close",
            "contentType": "Path",
            "content": "app/scripts/close/job.ps1",
            "runElevated": true,
            "restartAfter": false,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": false,
            "applyUpdateBefore": false
          },
          {
            "name": "Uninstall",
            "action": "Uninstall",
            "contentType": "Path",
            "content": "app/scripts/uninstall/job.ps1",
            "runElevated": true,
            "restartAfter": false,
            "maxRunTime": 1800,
            "runAsInteractive": true,
            "alwaysRun": true,
            "applyUpdateBefore": false
          }
        ]
      }
    ]
  }
}
```
