output "credential" {
  value = var.tfc_gcp_dynamic_credentials
}
output "pool_name" {
  value = data.google_iam_workload_identity_pool.pool.name
}
