terraform {
  required_version = ">= 1.9.2"
  required_providers {
    # alicloud = {
    #   source  = "aliyun/alicloud"
    #   version = ">=1.248.0"
    # }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}
