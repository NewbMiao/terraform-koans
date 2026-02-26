# ========================================
# Bootstrap Terraform Configuration
# ========================================
# Purpose: Create infrastructure and state storage for Terraform
# Usage: Run once to initialize the project, then no longer needed
# ========================================

# ========================================
# Azure DevOps Resources
# ========================================

# Create Azure DevOps Project
resource "azuredevops_project" "this" {
  name               = local.ado_project_name
  description        = local.ado_project_description
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

# Create Git Repository
resource "azuredevops_git_repository" "this" {
  project_id = azuredevops_project.this.id
  name       = local.ado_project_name
  initialization {
    init_type = "Clean"
  }
}

# ========================================
# Azure Resources
# ========================================

# Create Resource Group
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location

  tags = {
    Purpose   = "Terraform State Storage"
    ManagedBy = "Bootstrap"
  }
}

# Create Storage Account
resource "azurerm_storage_account" "this" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    Purpose   = "Terraform State Storage"
    ManagedBy = "Bootstrap"
  }
}

# ========================================
# Storage Containers
# ========================================

# Dev environment state container
resource "azurerm_storage_container" "dev" {
  name                  = "tfstate-dev"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

# Staging environment state container (optional)
# resource "azurerm_storage_container" "stg" {
#   name                  = "tfstate-stg"
#   storage_account_id    = azurerm_storage_account.this.id
#   container_access_type = "Private"
# }

# Production environment state container (optional)
# resource "azurerm_storage_container" "prod" {
#   name                  = "tfstate-prod"
#   storage_account_id    = azurerm_storage_account.this.id
#   container_access_type = "Private"
# }

# ========================================
# Outputs
# ========================================

output "storage_account_name" {
  description = "Storage Account name (for backend configuration)"
  value       = azurerm_storage_account.this.name
}

output "resource_group_name" {
  description = "Resource Group name (for backend configuration)"
  value       = azurerm_resource_group.this.name
}

output "containers" {
  description = "List of created containers"
  value = [
    azurerm_storage_container.dev.name,
    # azurerm_storage_container.stg.name,
    # azurerm_storage_container.prod.name
  ]
}

output "ado_project_id" {
  description = "Azure DevOps Project ID"
  value       = azuredevops_project.this.id
}




