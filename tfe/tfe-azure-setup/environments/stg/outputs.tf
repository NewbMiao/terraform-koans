# Outputs for Staging Environment

output "app_service_url" {
  description = "URL of the staging App Service"
  value       = "https://${module.app_service.app_service_default_hostname}"
}

output "mysql_server_fqdn" {
  description = "FQDN of the staging MySQL server"
  value       = module.app_service.mysql_server_fqdn
}

output "mysql_database_name" {
  description = "Name of the staging MySQL database"
  value       = module.app_service.mysql_database_name
}