# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

<#
.DESCRIPTION
    This script is used to check Test Base results.
    Need to install Azure PowerShell before using this script: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps
#>
#--------------------------------------------------------------------------------------------------------------
# Variables
#--------------------------------------------------------------------------------------------------------------

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
# Test Summaries - List
#--------------------------------------------------------------------------------------------------------------
#refer to https://docs.microsoft.com/en-us/rest/api/testbase/test-summaries/list
Function SummariesList {
    process {
        Write-Host "Test Summaries - List"
        $requestUrl = "https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.TestBase/testBaseAccounts/${testBaseAccountName}/testSummaries?api-version=2022-04-01-preview"
        $result = Invoke-RestMethod -Method GET -Uri "$requestUrl" -Headers $authHeader
        return $result.value
    }
}

Function isFailure {
    param (
        [string]$test_status
    )

    process {
      if (($test_status -eq "TestFailure") -or ($test_status -eq "UpdateFailure") -or ($test_status -eq "TestAndUpdateFailure") -or ($test_status -eq "InfrastructureFailure"))
      {
        return $True
      }
      return $False
    }
}

Function isRunIn24h{
    param (
        [string]$testRunTime
    )
    process {
        $startDate=[datetime]$testRunTime
        $endDate=(GET-DATE)
        $ds = New-TimeSpan -Start $startDate -End $endDate
        return $ds.Days -ge 1
    }
}

function Main {
    $failure_tests = @()
    $summary = SummariesList
    $summary | Foreach-Object{
        $item = $_.properties
        Write-Host $item.applicationName"-"$item.applicationVersion" "$item.executionStatus
        if ($item.executionStatus -eq "None" -or $item.testRunTime -eq "None"){
            Write-Host "No execution status or run time"
            return -1
        }
        # check if this summary is a run within last 24 hours
        Write-Host "Last Run time:"$item.testRunTime

        if(-Not (isRunIn24h($item.testRunTime))) {
            continue;
        }
        Write-Host "There is at least one run in the last day"
        if(isFailure($item.testStatus)) {
            if($item.featureUpdatesTestSummary) {
                $item.featureUpdatesTestSummary.osUpdateTestSummaries | Foreach-Object{
                    $fuSummary = $_
                    if(isFailure($suSummary.testStatus) -and isRunIn24h($fuSummary.testRunTime)) {
                       $failure_tests += [string]::Format("package_name:{0} version:{1}testType:{2} status:{3} runTime:{4} osName:{5} updateType:{6} release:{7} version:{8}",
                        $item.applicationName,
                        $item.applicationVersion,
                        $fuSummary.testType,
                        $fuSummary.testStatus,
                        $fuSummary.testRunTime,
                        $fuSummary.osName,
                        "Feature update",
                        $fuSummary.releaseName,
                        $fuSummary.buildVersion
                        )
                    }
                }
            }
            if($item.securityUpdatesTestSummary) {
                $item.securityUpdatesTestSummary.osUpdateTestSummaries | Foreach-Object{
                    $suSummary = $_
                    if(isFailure($suSummary.testStatus) -and isRunIn24h($suSummary.testRunTime)) {
                       $failure_tests += [string]::Format("package_name:{0} version:{1} testType:{2} status:{3} runTime:{4} osName:{5} updateType:{6} release:{7} version:{8}",
                        $item.applicationName,
                        $item.applicationVersion,
                        $suSummary.testType,
                        $suSummary.testStatus,
                        $suSummary.testRunTime,
                        $suSummary.osName,
                        "Security update",
                        $suSummary.releaseName,
                        $suSummary.buildVersion
                        )
                    }
                }
            }
        }
    }

    if ($failure_tests.Length -gt 0) {
        Write-Host $failure_tests.Length, "failed test in last 24 hours"
        $failure_tests | Foreach-Object{
            Write-Host $_
        }
        exit -1
    }else {
        exit 0
    }
}

Main
