# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

<#
.DESCRIPTION
    This script is used to update Test Base package with new zip file.
    Need to install Azure PowerShell before using this script: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$packagePath = '',
    [string]$applicationName = '',
    [string]$packageVersion = ''
)
#--------------------------------------------------------------------------------------------------------------
# Variables
#--------------------------------------------------------------------------------------------------------------
if (!(Test-Path $packagePath)) {
    Write-Error "Cannot find package: $packagePath"
    exit 1
}

$packageFileName = (Get-Item $packagePath).Name.ToLower()
$subscriptionId = $Env:AZURE_SUBSCRIPTION_ID
$clientId = $Env:AZURE_CLIENT_ID
$clientSecret = $Env:AZURE_CLIENT_SECRET
$tenantId = $Env:AZURE_TENANT_ID
$resourceGroupName = $Env:RESOURCE_GROUP_NAME
$testBaseAccountName = $Env:TESTBASE_ACCOUNT_NAME

#--------------------------------------------------------------------------------------------------------------
# Connect to Azure Account
#--------------------------------------------------------------------------------------------------------------
Write-Host "Sign in with a service principal."
az login --service-principal -u $clientId -p $clientSecret --tenant $tenantId
Write-Host "az account set --subscription $subscriptionId"
az account set --subscription $subscriptionId

Write-Host "Get Access Token"
$accessTokenString = $(az account get-access-token --query accessToken --output tsv)

$authHeader = @{
    "Authorization" = "Bearer $accessTokenString"
}

#--------------------------------------------------------------------------------------------------------------
# Get Available OSVersions For SecurityUpdate
#--------------------------------------------------------------------------------------------------------------
Function GetAvailableOSs {
    process {
        Write-Host "Get Available OSVersions For SecurityUpdate"        
        $requestUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/availableOSs?api-version=2023-05-15-preview&osUpdateType=SecurityUpdate"
        $result = Invoke-RestMethod -Method GET -Uri "$requestUrl" -Headers $authHeader
        return $result.value
    }
}

#--------------------------------------------------------------------------------------------------------------
# Create package
#--------------------------------------------------------------------------------------------------------------
#refer to https://docs.microsoft.com/en-us/rest/api/testbase/packages/update
Function CreatePackage {
    param (
        [string]$currUploadUrl,
        [string]$currTargetOS
    )
    process {
        Write-Host "Create package"
        CheckPackageSetting('PackageSetting.json')
        $packageName = $applicationName + "-" + $packageVersion
        $requestUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/packages/${packageName}?api-version=2023-05-15-preview"
        $packageSetting = Get-Content 'PackageSetting.json' | ConvertFrom-Json
        $packageSetting.properties[0].applicationName = "$applicationName"
        $packageSetting.properties[0].version = "$packageVersion"
        $packageSetting.properties[0].blobPath = $currUploadUrl.Substring(0, $currUploadUrl.IndexOf("?"))

        $currTargetOSList = 
        @(
            @{
                "targetOSs"    = @("$currTargetOS")
                "osUpdateType" = "Security updates"
            }                
        )
        $packageSetting.properties[0].targetOSList = $currTargetOSList
        $body = $packageSetting | ConvertTo-Json -Depth 10
        try {
            Invoke-RestMethod -Method PUT -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        }
        catch {
            Write-Host "Failed to create package"
            Write-Host $_
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# Update package
#--------------------------------------------------------------------------------------------------------------
#refer to https://docs.microsoft.com/en-us/rest/api/testbase/packages/update
Function UpdatePackage {
    param (
        [string]$currUploadUrl,
        [string]$currTargetOS
    )
    process {
        Write-Host "Update package"
        CheckPackageSetting('AppSetting.json')
        $packageName = $applicationName + "-" + $packageVersion
        $requestUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/packages/${packageName}?api-version=2022-05-01"
        $packageSetting = Get-Content 'AppSetting.json' | ConvertFrom-Json
        $packageSetting.properties[0].blobPath = $currUploadUrl.Substring(0, $currUploadUrl.IndexOf("?"))
        
        $currTargetOSList = 
        @(
            @{
                "targetOSs"    = @("$currTargetOS")
                "osUpdateType" = "Security updates"
            }                
        )
        $packageSetting.properties[0].targetOSList = $currTargetOSList
        $body = $packageSetting | ConvertTo-Json -Depth 10
        try {
            Invoke-RestMethod -Method PATCH -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        }
        catch {
            Write-Host "Failed to update package"
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# List package
#--------------------------------------------------------------------------------------------------------------
#refer to https://docs.microsoft.com/en-us/rest/api/testbase/packages/list-by-test-base-account
Function ListPackage {
    Write-Host "List package"
    $requestUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/packages?api-version=2022-04-01-preview"
    $result = Invoke-RestMethod -Method GET -Uri "$requestUrl" -Headers $authHeader
    return $result.value
}

#--------------------------------------------------------------------------------------------------------------
# Upload package zip
#--------------------------------------------------------------------------------------------------------------
# refer to https://docs.microsoft.com/en-us/rest/api/testbase/test-base-accounts/get-file-upload-url
Function UploadPackageZip {
    process {
        Write-Host "Upload package zip"
        $requestUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/getFileUploadUrl?api-version=2022-04-01-preview"
        $body = @{
            "blobName" = "$packageFileName"
        } | ConvertTo-Json -Depth 100

        $result = Invoke-RestMethod -Method Post -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        $uploadUrl = $result.uploadUrl

        #Define required Headers
        $headers = @{
            'x-ms-blob-type' = 'BlockBlob'
        }

        #Upload File...
        try {
            Invoke-RestMethod -Uri $uploadUrl -Method Put -Headers $headers -InFile $packagePath
        }
        catch {
            Write-Host "Failed to upload package zip"
            exit 1
        }
        return $uploadUrl
    }
}
Function CheckPackageSetting {
    param (
        [string]$packageSettingFileName
    )

    process {
        $packageSettingFile = "$PSScriptRoot\$packageSettingFileName"
        if (!(Test-Path $packageSettingFile)) {
            Write-Error "Cannot find package setting file: $packageSettingFile"
            exit 1
        }
    }
}

function Main {
    $availableOSs = GetAvailableOSs
    $arm64OS = $availableOSs | Where-Object { $_.properties.osArchitecture -eq "arm64" }
    $targetOS = $arm64OS[0].properties.osId
    $uploadUrl = UploadPackageZip

    $packageName = $applicationName + "-" + $packageVersion
    $packages = ListPackage

    $packageNotExist = $True;
    foreach ($item in $packages) {
        if ($item.name -eq $packageName) {
            $packageNotExist = $False
        }
    }
    if ($packageNotExist) {
        CreatePackage $uploadUrl $targetOS
    }
    else {
        UpdatePackage $uploadUrl $targetOS
    }
}

Main
