# ========================================
# Common Constants
# ========================================
# Purpose: Centralized configuration values used across bootstrap Terraform files
# ========================================

locals {
  # ========================================
  # Azure Configuration
  # ========================================
  resource_group_name = "rg-terraform-state"
  # storage_account_name - Uses random suffix for uniqueness (change if needed)
  storage_account_name = "tfstate${random_integer.storage_suffix.result}"
  location             = "eastasia"

  # ========================================
  # Azure DevOps Configuration
  # ========================================
  # ado_org_name - UPDATE THIS with your ADO organization (create at https://dev.azure.com/)
  ado_org_name            = "newbmiao"
  ado_project_name        = "tf-cicd"
  ado_project_description = "Terraform CI/CD Project"
}