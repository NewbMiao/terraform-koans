terraform {
  # use local mode, run plan and apply in local via localstack
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "newbmiao"
    workspaces {
      name = "tfe-aws-varsets"
    }
  }
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.66.0"
    }
  }
}
