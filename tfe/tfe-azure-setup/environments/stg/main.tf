# Staging Environment - Main Configuration

locals {
  environment = "stg"
  location    = "eastasia"
  prefix      = "stg-tf"
}

module "app_service" {
  source = "../../modules/app_service"

  resource_group_name = "rg-stg-tf"
  location            = local.location
  resource_prefix     = local.prefix
  environment         = local.environment

  tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = "terraform-koans"
  }

  # Staging environment - production-like resources for testing
  app_service_sku = "P1v3"
  dotnet_version  = "6.0"
}
