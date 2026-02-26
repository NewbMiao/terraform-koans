# Variables for Staging Environment

variable "mysql_admin_password" {
  description = "MySQL admin password for staging environment"
  type        = string
  sensitive   = true
}