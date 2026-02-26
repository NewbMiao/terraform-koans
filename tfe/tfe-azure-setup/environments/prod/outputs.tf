# Outputs for Production Environment

output "app_service_url" {
  description = "URL of the production App Service"
  value       = "https://${module.app_service.app_service_default_hostname}"
}

output "mysql_server_fqdn" {
  description = "FQDN of the production MySQL server"
  value       = module.app_service.mysql_server_fqdn
  sensitive   = true
}

output "mysql_database_name" {
  description = "Name of the production MySQL database"
  value       = module.app_service.mysql_database_name
}