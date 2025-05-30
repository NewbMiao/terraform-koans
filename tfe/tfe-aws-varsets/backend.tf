terraform {
  # use local mode, run plan and apply in local via localstack
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "newbmiao"
    workspaces {
      name = "tfe-aws-varsets"
    }
  }
}

