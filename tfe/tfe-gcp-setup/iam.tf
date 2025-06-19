resource "google_service_account" "sa_tf" {
  account_id   = "sa-tf-demo"
  display_name = "Service Account for Demo Development Terraform"
}

resource "google_service_account_iam_binding" "sa_tf_iam" {
  service_account_id = google_service_account.sa_tf.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.tfc_identity_pool.workload_identity_pool_id}/*"
  ]
}

# allow sa_tf to manage gcp resources
resource "google_project_iam_member" "sa_tf_editor" {
  project = google_service_account.sa_tf.project
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.sa_tf.email}"
}
### workload identity pool for terraform cloud
# https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines#by-pool
resource "google_iam_workload_identity_pool" "tfc_identity_pool" {
  workload_identity_pool_id = "terraform-pool"
  display_name              = "terraform-pool"
  description               = "Production Pool"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "tfc-oidc"
  display_name                       = "terraform-cloud-oidc"
  description                        = "Terraform Cloud OIDC Provider"
  disabled                           = false

  attribute_mapping = {
    "attribute.terraform_organization_id" = "assertion.terraform_organization_id"
    "google.subject"                      = "assertion.terraform_workspace_id"
    "attribute.terraform_workspace_name"  = "assertion.terraform_workspace_name"
  }

  oidc {
    issuer_uri = "https://app.terraform.io"
  }

  attribute_condition = "assertion.terraform_organization_id == '${data.tfe_organization.tfe_org.id}'"
}
