resource "tfe_variable_set" "tfe_varset_global" {
  name          = "global-varset"
  organization  = "newbmiao"
  global        = null # when has workspace_ids, global must be ignored
  workspace_ids = ["ws-WKkNYa1eByLQrhaH"]
  description   = "Global variable set for TFE"
  priority      = true
}
resource "tfe_variable" "tfe_var_gloabl" {
  key             = "global"
  value           = "test"
  category        = "env"
  sensitive       = true
  description     = "global var for tfe"
  variable_set_id = tfe_variable_set.tfe_varset_global.id
  depends_on      = [tfe_variable_set.tfe_varset_global]
}
# cross organization test
# 1.1 team token access within same org 
# 1.2 edge case: if only one member in the team, and has multi-org access, then team token can access cross org
# 2. user token access cross org if has permission

# e.g. No access issue happen here:
# │ Error: Error creating variable set global-varset2, for organization: cloudplatform2: resource not found
resource "tfe_variable_set" "tfe_varset_global2" {
  provider      = tfe.cloudplatform2
  name          = "global-varset2"
  organization  = "cloudplatform2"
  workspace_ids = ["ws-c7GRYWFMzTLr5aw3"]
  description   = "Global variable set for TFE"
  priority      = true
}

resource "tfe_variable" "tfe_var_gloabl2" {
  provider = tfe.cloudplatform2

  key             = "global2"
  value           = "test"
  category        = "env"
  sensitive       = true
  description     = "global var for tfe"
  variable_set_id = tfe_variable_set.tfe_varset_global2.id
  depends_on      = [tfe_variable_set.tfe_varset_global2]
}
