# add google provider
provider "google" {
  project     = "theta-totem-463301-e6"
  credentials = file("./gcp-sa.json")
}
provider "tfe" {
  hostname     = "app.terraform.io"
  organization = "newbmiao"
}
