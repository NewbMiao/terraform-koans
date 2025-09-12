terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "newbmiao"
    workspaces {
      name = "tfe-opa-policy"
    }
  }
  required_version = ">= 1.9.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.66.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "newbmiao"
}
provider "local" {}
# │ Warning: Incomplete lock file information for providers
# │ 
# │ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
# │   - hashicorp/local
# │ 
# │ The current .terraform.lock.hcl file only includes checksums for darwin_arm64, so Terraform running on another platform will fail to install these providers.
# │ 
# │ To calculate additional checksums for another platform, run:
# │   terraform providers lock -platform=linux_amd64
# │ (where linux_amd64 is the platform to generate)
