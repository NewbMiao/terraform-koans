# Variables for Dev Environment

variable "mysql_admin_password" {
  description = "MySQL admin password for dev environment"
  type        = string
  sensitive   = true
}