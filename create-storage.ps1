# Azure Storage Account Automation using Service Principal
# Author: Patryk Figas

$tenantId = $env:AZURE_TENANT_ID
$clientId = $env:AZURE_CLIENT_ID
$clientSecret = $env:AZURE_CLIENT_SECRET
$subscriptionId = $env:AZURE_SUBSCRIPTION_ID

$resourceGroupName = "rg-rekrutacja-patryk"
$location = "westeurope"
$storageAccountName = "stpatryk16882"

if ([string]::IsNullOrWhiteSpace($tenantId)) {
    Write-Error "Environment variable AZURE_TENANT_ID is not set."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($clientId)) {
    Write-Error "Environment variable AZURE_CLIENT_ID is not set."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($clientSecret)) {
    Write-Error "Environment variable AZURE_CLIENT_SECRET is not set."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($subscriptionId)) {
    Write-Error "Environment variable AZURE_SUBSCRIPTION_ID is not set."
    exit 1
}

$securePassword = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($clientId, $securePassword)

Write-Host "Logging in to Azure using Service Principal..."

Connect-AzAccount `
    -ServicePrincipal `
    -TenantId $tenantId `
    -Credential $credential

Set-AzContext -SubscriptionId $subscriptionId

Write-Host "Checking if Storage Account already exists..."

$existingStorageAccount = Get-AzStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -ErrorAction SilentlyContinue

if ($existingStorageAccount) {
    Write-Host "Storage Account already exists: $storageAccountName"
}
else {
    Write-Host "Creating Storage Account: $storageAccountName"

    New-AzStorageAccount `
        -ResourceGroupName $resourceGroupName `
        -Name $storageAccountName `
        -Location $location `
        -SkuName Standard_LRS `
        -Kind StorageV2

    Write-Host "Storage Account created successfully: $storageAccountName"
}

Write-Host "Done."