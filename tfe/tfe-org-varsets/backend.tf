terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "newbmiao"
    workspaces {
      name = "tfe-org-varsets"
    }
  }
  # required_providers {

  #   tfe = {
  #     source  = "hashicorp/tfe"
  #     version = ">= 0.66.0"
  #   }
  # }
}
