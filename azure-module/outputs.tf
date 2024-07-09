output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.example.ip_address
}

output "sql_server_name" {
  value = azurerm_mssql_server.example.name
}

output "location" {
  value = azurerm_resource_group.example.location
}

output "resource_group_name"{
    value = azurerm_resource_group.example.name
}
output "subnet_id" {
  value = azurerm_subnet.example.id
}