output "application_public_address" {
  value = azurerm_public_ip.wordpress.fqdn
}

output "db_name" {
  value = azurerm_mysql_server.wordpress.name
}
# Gives the DB host address
#output "db_addr" {
  #value = azurerm_mysql_server.wordpress.address
#}
# Gives the username for DB access
output "administrator_login" {
  value = azurerm_mysql_server.wordpress.username
}
# Gives the password for DB access
output "dadministrator_login_password" {
  value = azurerm_mysql_server.wordpress.password
}