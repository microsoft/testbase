# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

<#
.DESCRIPTION
    This script is used to create Test Base package with intune file.    
#>

#--------------------------------------------------------------------------------------------------------------
# Variables
#--------------------------------------------------------------------------------------------------------------
./config.ps1

if (!(Test-Path $intuneFilePath)) {
    Write-Error "Cannot find package: $intuneFilePath"
    exit 1
}

$ituneFileName = (Get-Item $intuneFilePath).Name.ToLower()
$draftPackageName = (New-Guid).guid

#--------------------------------------------------------------------------------------------------------------
# Connect to Azure Account
#--------------------------------------------------------------------------------------------------------------
Write-Host "Sign in with a service principal."
az login --use-device-code 

Write-Host "az account set --subscription $subscriptionId"
az account set --subscription $subscriptionId

Write-Host "Get Access Token"
$accessTokenString = $(az account get-access-token --query accessToken --output tsv)

$authHeader = @{
    "Authorization" = "Bearer $accessTokenString"
}

Write-Host "Get graph API Access Token"
$graphAuthHeader = @{
    "Authorization" = "Bearer $graphAccessTokenString"
}

#--------------------------------------------------------------------------------------------------------------
# List Intune Apps
#--------------------------------------------------------------------------------------------------------------
Function ListIntuneApps {
    process {
        Write-Host "List Intune Apps"        
        $requestUrl = "${graphUri}/${intuneGraphBaseUri}/deviceAppManagement/mobileApps?" + '$filter=((microsoft.graph.managedApp/appAvailability%20eq%20null%20or%20microsoft.graph.managedApp/appAvailability%20eq%20%27lineOfBusiness%27%20or%20isAssigned%20eq%20true)%20and%20(isof(%27microsoft.graph.win32LobApp%27)))&$orderby=displayName&$top=20'
        $result = Invoke-RestMethod -Method GET -Uri "$requestUrl" -Headers $graphAuthHeader
        return $result.value
    }
}

#--------------------------------------------------------------------------------------------------------------
# Get IntuneDependent App
#--------------------------------------------------------------------------------------------------------------
Function GetAndUpdateIntuneDependentApp {
    param (
        $intuneApp
    )
    process {
        if ($intuneApp.dependentAppCount -eq 0) {
            return
        }
        $intuneAppId = ${intuneApp}.id
        Write-Host "Get relationships by ${intuneAppId}"         
        $requestUrl = "${graphUri}/${intuneGraphBaseUri}/deviceAppManagement/mobileApps/${intuneAppId}/relationships"
        $result = Invoke-RestMethod -Method GET -Uri "$requestUrl" -Headers $graphAuthHeader

        $targetId = $result.value.targetId
        if ($targetId) {
            Write-Host "Get DependentApp by ${targetId}"         
            $getUrl = "${graphUri}/${intuneGraphBaseUri}/deviceAppManagement/mobileApps/${targetId}"
            $dependentAppResult = Invoke-RestMethod -Method GET -Uri "$getUrl" -Headers $graphAuthHeader
    
            $currObj = @{
                'appName'          = $dependentAppResult.id
                'appId'            = $dependentAppResult.displayName
                'installCommand'   = $dependentAppResult.installCommandLine
                'uninstallCommand' = $dependentAppResult.uninstallCommandLine
                'status'           = 4
            }
    
            $draftPackageSetting.properties[0].intuneMetadata.intuneAppDependencies += $currObj     
        }           
    }
}

#--------------------------------------------------------------------------------------------------------------
# Update Intune App Data
#--------------------------------------------------------------------------------------------------------------
Function UpdateIntuneAppData {
    param (
        $intuneApp
    )
    process {
        Write-Host "Update IntuneApp Data"   
        if ($intuneApp) {
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp.createDate = $intuneApp.createdDateTime
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'appId' -Value $intuneApp.id -MemberType NoteProperty
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'appName' -Value $intuneApp.displayName -MemberType NoteProperty
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'version' -Value  $intuneApp.displayVersion -MemberType NoteProperty
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'uninstallCommand' -Value  $intuneApp.uninstallCommandLine -MemberType NoteProperty
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'installCommand' -Value  $intuneApp.installCommandLine -MemberType NoteProperty
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'owner' -Value  $intuneApp.owner -MemberType NoteProperty
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'description' -Value  $intuneApp.description -MemberType NoteProperty
            $draftPackageSetting.properties[0].intuneMetadata.intuneApp | Add-Member -Name 'publisher' -Value  $intuneApp.publisher -MemberType NoteProperty
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# Create draft package
#--------------------------------------------------------------------------------------------------------------
Function CreateDraftPackage {
    process {
        Write-Host "Create draft package"       
        $requestUrl = "$armEndpoint/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/draftPackages/${draftPackageName}?api-version=2023-01-01-preview"
        $body = @{} | ConvertTo-Json -Depth 10
        try {
            Invoke-RestMethod -Method PUT -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        }
        catch {
            Write-Host "Failed to create package"
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# Get draft package path
#--------------------------------------------------------------------------------------------------------------
Function GetDraftPackagePath {
    process {
        Write-Host "Get draft package path"
        
        $requestUrl = "$armEndpoint/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/draftPackages/${draftPackageName}/getPath?api-version=2023-01-01-preview"
        $result = Invoke-RestMethod -Method POST -Uri "$requestUrl" -Headers $authHeader -ContentType "application/json"
        return $result
    }
}

#--------------------------------------------------------------------------------------------------------------
# Upload Intune file
#--------------------------------------------------------------------------------------------------------------
Function UploadIntuneFile {
    param (
        $pathData
    )
    process {       
        $baseUrl = $pathData.baseUrl
        $workingPath = $pathData.workingPath
        $sasToken = $pathData.sasToken
        $uploadUrl = "${baseUrl}/${workingPath}/bin/${ituneFileName}?${sasToken}"
        Write-Host "Upload Intune zip"
        #Define required Headers
        $headers = @{
            'x-ms-blob-type' = 'BlockBlob'
        }
        #Upload File...
        try {
            Invoke-RestMethod -Uri $uploadUrl -Method Put -Headers $headers -InFile $intuneFilePath
        }
        catch {
            Write-Host "Failed to upload package zip"
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# Extract File
#--------------------------------------------------------------------------------------------------------------
Function ExtractFile {
    process {
        Write-Host "Extract File"        
        $requestUrl = "$armEndpoint/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/draftPackages/${draftPackageName}/extractFile?api-version=2023-01-01-preview"

        #Define required body
        $request = @{
            'sourceFile' = "bin/${ituneFileName}"
        }
        $body = $request | ConvertTo-Json -Depth 10

        try {
            Invoke-RestMethod -Method POST -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        }
        catch {
            Write-Host "Failed to extract file"
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# Generate Folders And Scripts
#--------------------------------------------------------------------------------------------------------------
Function GenerateFoldersAndScripts {
    process {       
        Write-Host "Generate Folders And Scripts" 
        $requestUrl = "$armEndpoint/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/draftPackages/${draftPackageName}/generateFoldersAndScripts?api-version=2023-01-01-preview"
        $body = @{} | ConvertTo-Json -Depth 10
        
        try {
            Invoke-RestMethod -Method POST -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        }
        catch {
            Write-Host "Failed to Generate Folders And Scripts"
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# update draft package
#--------------------------------------------------------------------------------------------------------------
Function PatchDraftPackage {
    param (
        [string]$tab
    )

    process {
        Write-Host "update draft package"        
        $requestUrl = "$armEndpoint/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/draftPackages/${draftPackageName}?api-version=2023-01-01-preview"
        $draftPackageSetting.properties[0].applicationName = "$applicationName"
        $draftPackageSetting.properties[0].version = "$packageVersion"
        $body = $draftPackageSetting | ConvertTo-Json -Depth 10
        try {
            Invoke-RestMethod -Method PATCH -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        }
        catch {
            Write-Host "Failed to update draft package"
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# create package
#--------------------------------------------------------------------------------------------------------------
Function CreatePackage {
    process {
        Write-Host "create package"
        CheckPackageSetting('PackageSetting.json')
        $packageName = $applicationName + "-" + $packageVersion
        $requestUrl = "$armEndpoint/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/packages/${packageName}?api-version=2023-01-01-preview"
        $packageSetting = Get-Content 'PackageSetting.json' | ConvertFrom-Json
        $packageSetting.properties[0].applicationName = "$applicationName"
        $packageSetting.properties[0].version = "$packageVersion"
        $packageSetting.properties[0].draftPackageId = "/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/draftPackages/${draftPackageName}"
        $body = $packageSetting | ConvertTo-Json -Depth 10
        try {
            Invoke-RestMethod -Method PUT -Uri "$requestUrl" -Headers $authHeader -Body $body -ContentType "application/json"
        }
        catch {
            Write-Host "Failed to update draft package"
            exit 1
        }
    }
}

#--------------------------------------------------------------------------------------------------------------
# Delete Draft Package
#--------------------------------------------------------------------------------------------------------------
Function DeleteDraftPackage {
    process {
        Write-Host "Delete Draft Package"
        $requestUrl = "$armEndpoint/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/draftPackages/${draftPackageName}?api-version=2023-01-01-preview"
        try {
            Invoke-RestMethod -Method DELETE -Uri "$requestUrl" -Headers $authHeader
        }
        catch {
            Write-Host "Failed to Delete Draft Package"
            exit 1
        }
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

CheckPackageSetting('DraftPackageSetting.json')
$draftPackageSetting = Get-Content 'DraftPackageSetting.json' | ConvertFrom-Json
function Main {    
    $apps = ListIntuneApps
    UpdateIntuneAppData($apps[0])
    GetAndUpdateIntuneDependentApp($apps[0])
    CreateDraftPackage   
    $pathData = GetDraftPackagePath
    UploadIntuneFile($pathData)
    ExtractFile    
    PatchDraftPackage
    GenerateFoldersAndScripts    
    CreatePackage
    DeleteDraftPackage
}

Main
