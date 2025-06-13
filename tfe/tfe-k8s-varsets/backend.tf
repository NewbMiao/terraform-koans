terraform {
  # use local mode, run plan and apply in local via localstack
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "newbmiao"
    workspaces {
      name = "tfe-k8s-varsets"
    }
  }
  required_version = ">= 1.9.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.66.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}
