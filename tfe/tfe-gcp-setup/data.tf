data "google_project" "project" {
}

data "tfe_workspace" "tfe_gcp_workload_identity" {
  name = "tfe-gcp-workload-identity"
}

data "tfe_project" "cloudplatform" {
  name = "cloudplatform"
}

data "tfe_organization" "tfe_org" {
  name = "newbmiao"
}
