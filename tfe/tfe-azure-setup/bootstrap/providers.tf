# ========================================
# Terraform Provider Configuration
# ========================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.8.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.61.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.8.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.13.0"
    }
  }
}

# ========================================
# Provider Configurations
# ========================================

provider "random" {}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/${local.ado_org_name}"
  # Use AZURE_DEVOPS_EXT_PAT environment variable for authentication
}