resource "tfe_variable_set" "gcp_varset" {
  name              = "gcp-varset"
  parent_project_id = data.tfe_project.cloudplatform.id
  workspace_ids     = [data.tfe_workspace.tfe_gcp_workload_identity.id]
}
resource "tfe_variable" "gcp_varset_variable_project_number" {
  variable_set_id = tfe_variable_set.gcp_varset.id
  key             = "TFC_GCP_PROJECT_NUMBER"
  value           = data.google_project.project.number
  category        = "env"
}
resource "tfe_variable" "gcp_varset_variable_provider_auth" {
  variable_set_id = tfe_variable_set.gcp_varset.id
  key             = "TFC_GCP_PROVIDER_AUTH"
  value           = true
  category        = "env"
}
resource "tfe_variable" "gcp_varset_variable_run_service_account_email" {
  variable_set_id = tfe_variable_set.gcp_varset.id
  key             = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value           = google_service_account.sa_tf.email
  category        = "env"
}
resource "tfe_variable" "gcp_varset_variable_workload_pool_id" {
  variable_set_id = tfe_variable_set.gcp_varset.id
  key             = "TFC_GCP_WORKLOAD_POOL_ID"
  value           = google_iam_workload_identity_pool.tfc_identity_pool.workload_identity_pool_id
  category        = "env"
}
resource "tfe_variable" "gcp_varset_variable_workload_provider_id" {
  variable_set_id = tfe_variable_set.gcp_varset.id
  key             = "TFC_GCP_WORKLOAD_PROVIDER_ID"
  value           = google_iam_workload_identity_pool_provider.pool_provider.workload_identity_pool_provider_id
  category        = "env"
}
