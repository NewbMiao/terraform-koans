# Production Environment - Main Configuration

locals {
  environment = "prod"
  location    = "eastasia"
  prefix      = "prod-tf"
}

module "app_service" {
  source = "../../modules/app_service"

  resource_group_name = "rg-prod-tf"
  location            = local.location
  resource_prefix     = local.prefix
  environment         = local.environment

  tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = "terraform-koans"
  }

  # Production 环境 - 高可用配置
  app_service_sku = "P2v3"
  dotnet_version  = "6.0"
}
