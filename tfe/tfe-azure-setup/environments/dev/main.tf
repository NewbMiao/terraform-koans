# Dev Environment - Main Configuration

locals {
  environment = "dev"
  location    = "eastasia"
  prefix      = "dev-tf"
}

module "app_service" {
  source = "../../modules/app_service"

  resource_group_name = "rg-dev-tf"
  location            = local.location
  resource_prefix     = local.prefix
  environment         = local.environment

  tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = "terraform-koans"
  }

  # Dev environment - minimal resources
  app_service_sku = "B1"
  dotnet_version  = "6.0"
}
