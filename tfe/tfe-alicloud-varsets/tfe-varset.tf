locals {
  tfe_project_ids = {
    cloudplatform = "prj-ifPU81zqNih2NHxM",
  }
}

resource "tfe_variable_set" "tfe_varset_cloudplatform" {
  for_each          = local.tfe_project_ids
  name              = "${each.key}-tfe-account"
  parent_project_id = each.value.project_id
  workspace_ids     = each.value.workspace_ids
  description       = "AKSK ENV Set for alicloud tfe account in project ${each.key}"
  priority          = false
}

resource "tfe_variable" "cloudplatform_ali_access_key" {
  for_each        = local.tfe_project_ids
  key             = "ALIBABA_CLOUD_ACCESS_KEY_ID"
  value           = "access_key_id_placeholder"
  category        = "env"
  sensitive       = true
  description     = "alicloud access key for tfe"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}

resource "tfe_variable" "cloudplatform_ali_access_secret" {
  for_each        = local.tfe_project_ids
  key             = "ALIBABA_CLOUD_ACCESS_KEY_SECRET"
  value           = "access_key_secret_placeholder"
  category        = "env"
  sensitive       = true
  description     = "alicloud secret key for tfe"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}
resource "tfe_variable" "cloudplatform_ali_role_arn" {
  for_each        = local.tfe_project_ids
  key             = "ALIBABA_CLOUD_ROLE_ARN"
  value           = "acs:ram::000000000:role/tfe-membre-role"
  category        = "env"
  description     = "alicloud assume role arn for tfe"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}
resource "tfe_variable" "cloudplatform_ali_region" {
  for_each        = local.tfe_project_ids
  key             = "ALIBABA_CLOUD_REGION"
  value           = "cn-shanghai"
  category        = "env"
  description     = "alicloud default region for tfe"
  variable_set_id = tfe_variable_set.tfe_varset_cloudplatform[each.key].id
  depends_on      = [tfe_variable_set.tfe_varset_cloudplatform]
}
