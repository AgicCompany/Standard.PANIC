output "resource_group_name" {
  description = "Name of the test resources resource group"
  value       = azurerm_resource_group.test.name
}

output "storage_account_id" {
  description = "ID of the test storage account"
  value       = azurerm_storage_account.test.id
}

output "storage_account_name" {
  description = "Name of the test storage account"
  value       = azurerm_storage_account.test.name
}



