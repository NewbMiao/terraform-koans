# Variables for Production Environment

variable "mysql_admin_password" {
  description = "MySQL admin password for production environment"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.mysql_admin_password) >= 24
    error_message = "生产环境密码长度必须至少 24 位"
  }
}

variable "mysql_subnet_id" {
  description = "Subnet ID for MySQL (required for prod private networking)"
  type        = string
}

variable "mysql_private_dns_zone_id" {
  description = "Private DNS Zone ID for MySQL (required for prod private networking)"
  type        = string
}