variable "cloudplatform2_token" {
  type = string
}
provider "tfe" {

  hostname     = "app.terraform.io"
  organization = "newbmiao"
}

provider "tfe" {
  alias = "cloudplatform2"

  token        = var.cloudplatform2_token
  hostname     = "app.terraform.io"
  organization = "cloudplatform2"
}
