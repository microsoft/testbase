# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

#Search app from https://apps.microsoft.com/, and copy the link
$global:AppStoreURL = "https://www.microsoft.com/en-us/p/microsoft-to-do-lists-tasks-reminders/9nblggh5r558"
#Specifies the name of a particular package with "Get-AppxPackage -Name *<appName>*" the AppId is the "<PackageFamilyName>!App"
$global:AppId = "Microsoft.Todos_8wekyb3d8bbwe!App"
$global:AppProcessName = "Todo"
