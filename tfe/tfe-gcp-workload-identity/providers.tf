
provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "newbmiao"
}


variable "tfc_gcp_dynamic_credentials" {
  description = "Object containing GCP dynamic credentials configuration"
  type = object({
    default = object({
      credentials = string
    })
    aliases = map(object({
      credentials = string
    }))
  })
}
provider "google" {
  project     = "theta-totem-463301-e6"
  credentials = var.tfc_gcp_dynamic_credentials.default.credentials
}
