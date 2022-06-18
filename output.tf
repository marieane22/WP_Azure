output "application_public_address" {
  value = azurerm_public_ip.wordpress.fqdn
}

output "db_name" {
  value = azurerm_mysql_server.wordpress.name
}
# Gives the DB host address
#output "mysql_addr" {
  #value = azurerm_mysql_server.wordpress.name.address
#}
# Gives the username for DB access
output "database_admin_login"{
  value = azurerm_mysql_server.wordpress.administrator_login
}

# Gives the password for DB access
output "database_admin_password"{
  value = azurerm_mysql_server.wordpress.administrator_login_password
}
