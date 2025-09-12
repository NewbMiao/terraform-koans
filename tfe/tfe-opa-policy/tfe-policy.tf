resource "tfe_policy" "deny_secret_files" {
  name         = "deny-secret-files"
  description  = "Prevents secret file creation via local_file"
  kind         = "opa"
  policy       = file("${path.module}/policies/deny_secret_files.rego")
  query        = "data.terraform.deny" # Required for OPA: Path to the Rego rule (data.<package>.<rule>)
  enforce_mode = "mandatory"           # advisory or mandatory
}

data "tfe_workspace" "tfe_opa_policy" {
  name = "tfe-opa-policy"
}
resource "tfe_policy_set" "secret_policy_set" {
  name        = "opa-denial-set"
  description = "OPA policy set of deny policies"
  kind        = "opa"
  policy_ids  = [tfe_policy.deny_secret_files.id]

  workspace_ids = [data.tfe_workspace.tfe_opa_policy.id]
}
