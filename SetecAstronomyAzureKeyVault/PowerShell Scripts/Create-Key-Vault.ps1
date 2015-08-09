$env:PSModulePath += ";C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager"
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager\AzureResourceManager.psd1" # <-- Now you can do this!

Import-AzurePublishSettingsFile "C:\azure\azure-credentials.publishsettings"

Write-Host 'Check For Vault'
Get-AzureKeyVault -VaultName 'Setec'

Write-Host 'Remove Vault'
Remove-AzureKeyVault -VaultName 'Setec' -Force

Write-Host 'Add Resource Group'
New-AzureResourceGroup –Name 'SetecAstronomy' –Location 'East US' -Force

Write-Host 'Add Vault'
New-AzureKeyVault -VaultName 'Setec' -ResourceGroupName 'SetecAstronomy' -Location 'East US'

Write-Host 'Add FirstSecret'
$secretvalue = ConvertTo-SecureString -String "I leave message here on service but you do not call" -AsPlainText -Force
$secret = Set-AzureKeyVaultSecret -VaultName "Setec" -Name "FirstSecret" -SecretValue $secretvalue

Write-Host "FirstSecret ID: " + $secret.Id

$AzureADApplicationKey = 'Insert Azure AD Application Key Here'
Set-AzureKeyVaultAccessPolicy -VaultName 'Setec' -ServicePrincipalName $AzureADApplicationKey -PermissionsToSecrets all -PermissionsToKeys all
