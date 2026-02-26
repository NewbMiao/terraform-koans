# ========================================
# OIDC Configuration for Azure DevOps
# ========================================
# Purpose: Configure Workload Identity Federation for passwordless authentication
# ========================================

# ========================================
# Azure AD Application and Service Principal
# ========================================

data "azurerm_client_config" "current" {}

resource "azuread_application" "terraform" {
  display_name     = "ado-terraform"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "terraform" {
  client_id = azuread_application.terraform.client_id
}

# ========================================
# Role Assignment
# ========================================

# Assign Contributor role at subscription level
# Note: For production, consider using Resource Group level or custom role for least privilege
resource "azurerm_role_assignment" "contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.terraform.object_id
}

# ========================================
# Federated Identity Credentials
# ========================================

# Dev environment
resource "azuread_application_federated_identity_credential" "dev" {
  application_id = azuread_application.terraform.id
  display_name   = "terraform-dev"
  description    = "Federated credential for Dev environment"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://vstoken.dev.azure.com/${local.ado_org_name}"
  subject        = "sc:tf:${local.ado_org_name}/${local.ado_project_name}:env:dev"
}

# Staging environment (optional)
# resource "azuread_application_federated_identity_credential" "stg" {
#   application_id = azuread_application.terraform.id
#   display_name   = "terraform-stg"
#   description    = "Federated credential for Staging environment"
#   audiences      = ["api://AzureADTokenExchange"]
#   issuer         = "https://vstoken.dev.azure.com/${local.ado_org_name}"
#   subject        = "sc:tf:${local.ado_org_name}/${local.ado_project_name}:env:stg"
# }

# Production environment (optional)
# resource "azuread_application_federated_identity_credential" "prod" {
#   application_id = azuread_application.terraform.id
#   display_name   = "terraform-prod"
#   description    = "Federated credential for Production environment"
#   audiences      = ["api://AzureADTokenExchange"]
#   issuer         = "https://vstoken.dev.azure.com/${local.ado_org_name}"
#   subject        = "sc:tf:${local.ado_org_name}/${local.ado_project_name}:env:prod"
# }

# ========================================
# Outputs
# ========================================

output "azure_ad_application_id" {
  description = "Azure AD Application ID (for ADO Service Connection)"
  value       = azuread_application.terraform.client_id
}

output "azure_ad_application_display_name" {
  description = "Azure AD Application display name"
  value       = azuread_application.terraform.display_name
}

output "service_connection_name" {
  description = "Service Connection name to use in Azure DevOps"
  value       = "sc-azure-oidc"
}

output "ado_org_project" {
  description = "ADO Organization/Project configured for OIDC"
  value       = "${local.ado_org_name}/${local.ado_project_name}"
}
