# Azure Storage Account Automation using PowerShell and Service Principal

## Task Description

The goal of this task was to design and implement a cloud infrastructure automation process in Microsoft Azure using PowerShell and a Service Principal.

The script logs in to Azure without requiring interactive user authentication in a browser, and then automatically creates an Azure Storage Account resource in a dedicated Resource Group.

## Technologies Used

* Microsoft Azure
* PowerShell
* Azure PowerShell module `Az`
* Service Principal
* Azure Role-Based Access Control
* Azure Storage Account

## Solution Assumptions

The solution uses a Service Principal, which is a technical account intended for applications, scripts, and automation processes.

The Service Principal authenticates to Azure using three main parameters:

* `tenant_id` — the identifier of the Microsoft Entra ID directory,
* `client_id` — the Application ID of the created Service Principal,
* `client_secret` — the secret used as a technical password.

After successful authentication, the script gains access to the selected Azure subscription and performs operations within the defined permission scope.

## Permission Scope

The Service Principal was assigned the following role:

```text
Contributor
```

at the level of the dedicated Resource Group:

```text
rg-rekrutacja-patryk
```

As a result, the technical account can create and manage resources only within this specific Resource Group, not across the entire subscription.

This approach limits the access scope and is safer than assigning global permissions.

## Created Resource

As part of the task, the following Azure Storage Account was created:

```text
Storage Account Name: stpatryk16882
Resource Group: rg-rekrutacja-patryk
Location: westeurope
SKU: Standard_LRS
Kind: StorageV2
ProvisioningState: Succeeded
```

## How the Script Works

The script performs the following steps:

1. Retrieves the Service Principal credentials from environment variables.
2. Checks whether the required variables are set.
3. Creates a `PSCredential` object based on the `client_id` and `client_secret`.
4. Logs in to Azure using the `Connect-AzAccount` command with the `-ServicePrincipal` parameter.
5. Sets the correct subscription context.
6. Checks whether the Storage Account already exists.
7. If the Storage Account does not exist, it creates it using `New-AzStorageAccount`.
8. If the Storage Account already exists, it displays an informational message and does not create a duplicate.

## Security

Sensitive data, such as `client_secret`, is not stored directly in the code.

The script uses environment variables:

```powershell
$env:AZURE_TENANT_ID
$env:AZURE_CLIENT_ID
$env:AZURE_CLIENT_SECRET
$env:AZURE_SUBSCRIPTION_ID
```

This ensures that the Service Principal secret is not stored in the GitHub repository.

## Requirements

Before running the script, the following requirements must be met:

* an Azure account,
* access to the selected subscription,
* the `Az` PowerShell module installed,
* a created Service Principal,
* the `Contributor` role assigned to the Service Principal on the dedicated Resource Group.

Installation of the `Az` module:

```powershell
Install-Module Az -Scope CurrentUser -Repository PSGallery -Force
```

## Environment Variable Configuration

Before running the script, the required environment variables must be set:

```powershell
$env:AZURE_TENANT_ID = "YOUR_TENANT_ID"
$env:AZURE_CLIENT_ID = "YOUR_CLIENT_ID"
$env:AZURE_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
$env:AZURE_SUBSCRIPTION_ID = "YOUR_SUBSCRIPTION_ID"
```

The values of `tenant_id`, `client_id`, `client_secret`, and `subscription_id` should not be stored directly in the source code.

## Running the Script

To run the script, execute the following command:

```powershell
.\create-storage.ps1
```

## Example Result

After the script was executed successfully, the Storage Account was created in Azure:

```text
StorageAccountName ResourceGroupName    PrimaryLocation SkuName      Kind      AccessTier ProvisioningState
------------------ -----------------    --------------- -------      ----      ---------- -----------------
stpatryk16882      rg-rekrutacja-patryk westeurope      Standard_LRS StorageV2 Hot        Succeeded
```

The `Succeeded` state confirms that the resource was created correctly.

## Summary

During the task, the following steps were completed:

* logged in to Azure using a user account,
* created a Service Principal,
* assigned the `Contributor` role to the Service Principal on the Resource Group,
* logged in to Azure as the Service Principal,
* created a Storage Account using PowerShell,
* confirmed the resource creation using the `Get-AzStorageAccount` command.

## Conclusions

This task confirms that it is possible to automatically create resources in Azure without interactive human login through a browser.

Authentication is performed programmatically using a Service Principal with limited permissions to a specific Resource Group. As a result, the script can be used in automation scenarios, such as CI/CD processes, deployments, or cloud infrastructure administration.
