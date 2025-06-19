terraform {
  # use remote agent mode, run plan and apply in remote via workload identity provider from tfc
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "newbmiao"
    workspaces {
      name = "tfe-gcp-workload-identity"
    }
  }
  required_version = ">= 1.9.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.66.0"
    }
  }
}
