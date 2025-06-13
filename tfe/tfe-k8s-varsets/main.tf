# create a TFE variable set for Kubernetes
# generate cert via shell script

resource "null_resource" "generate_k8s_cert" {
  provisioner "local-exec" {
    command = <<EOT
      bash get-cert.sh
    EOT
  }
}

data "tfe_project" "cloudplatform" {
  name = "cloudplatform"
}
data "tfe_workspace" "tfe_k8s_varsets" {
  name = "tfe-k8s-varsets"
}
locals {
  k8s_credential = try(
    jsondecode(file("${path.module}/tmp_k8s_config.json")),
    {
      host : "",
      client_certificate : "",
      client_key : "",
      cluster_ca_certificate : ""
    }
  )
}
resource "tfe_variable_set" "k8s_varset" {
  name              = "k8s-varset"
  parent_project_id = data.tfe_project.cloudplatform.id
  workspace_ids     = [data.tfe_workspace.tfe_k8s_varsets.id]
  description       = "Kubernetes variable set for TFE"
  priority          = false
}
resource "tfe_variable" "k8s_credential_host" {
  key             = "KUBE_HOST"
  value           = local.k8s_credential.host
  category        = "env"
  variable_set_id = tfe_variable_set.k8s_varset.id
}
# Option 1 (Recommended)
variable "k8s_credential" {
  type = object({
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
  description = "k8s credential"
  sensitive   = true
  default = {
    client_certificate     = ""
    client_key             = ""
    cluster_ca_certificate = ""
  }
}

# provider "kubernetes" {
#   client_certificate     = base64decode(var.k8s_credential.client_certificate)
#   client_key             = base64decode(var.k8s_credential.client_key)
#   cluster_ca_certificate = base64decode(var.k8s_credential.cluster_ca_certificate)
#   # host                   = local.k8s_credential.host # or use tfe env variable
# }
resource "tfe_variable" "k8s_credential" {
  key      = "k8s_credential"
  value    = jsonencode(local.k8s_credential)
  category = "terraform"
  hcl      = true
  /*
  Enable hcl parse is bad for existing sensitive variable (PS. So use each variable instead is better)
    Error: Error updating variable
  with module.tfe_user_acct_dscore_d7.tfe_variable.cloudplatform_ali_ack_credential["pe-dscore-nonprod"]
  on module/tfe-user/main.tf line 126, in resource "tfe_variable" "cloudplatform_ali_ack_credential":
  resource "tfe_variable" "cloudplatform_ali_ack_credential" {
  Couldn't update variable var-q6aqUbYLxuJ1cnro: invalid attribute

  Hcl cannot be updated for a sensitive variable
  */

  sensitive = true

  variable_set_id = tfe_variable_set.k8s_varset.id
}
# Oprion 2
variable "k8s_credential_client_certificate" {
  type        = string
  description = "client cert of k8s"
  sensitive   = true
  default     = ""
}
variable "k8s_credential_client_key" {
  type        = string
  description = "client key of k8s"
  sensitive   = true
  default     = ""
}
variable "k8s_credential_cluster_ca_certificate" {
  type        = string
  description = "cluster cert of k8s"
  sensitive   = true
  default     = ""
}

# provider "kubernetes" {
#   client_certificate     = base64decode(var.k8s_credential_client_certificate)
#   client_key             = base64decode(var.k8s_credential_client_key)
#   cluster_ca_certificate = base64decode(var.k8s_credential_cluster_ca_certificate)
#   # host                   = local.k8s_credential.host # or use tfe env variable
# }
resource "tfe_variable" "k8s_credential_client_certificate" {
  key             = "k8s_credential_client_certificate"
  value           = local.k8s_credential.client_certificate
  category        = "terraform"
  sensitive       = true
  variable_set_id = tfe_variable_set.k8s_varset.id
}
resource "tfe_variable" "k8s_credential_client_key" {
  key             = "k8s_credential_client_key"
  value           = local.k8s_credential.client_key
  category        = "terraform"
  sensitive       = true
  variable_set_id = tfe_variable_set.k8s_varset.id
}
resource "tfe_variable" "k8s_credential_cluster_ca_certificate" {
  key             = "k8s_credential_cluster_ca_certificate"
  value           = local.k8s_credential.cluster_ca_certificate
  category        = "terraform"
  sensitive       = true
  variable_set_id = tfe_variable_set.k8s_varset.id
}
/*
Can't use environment variable for client certificate, key, and cluster ca certificate
╷
│ Error: Error updating variable
│ 
│   with tfe_variable.k8s_credential_client_certificate,
│   on main.tf line 42, in resource "tfe_variable" "k8s_credential_client_certificate":
│   42: resource "tfe_variable" "k8s_credential_client_certificate" {
│ 
│ Couldn't update variable var-XAavAVzLwwdRyFUr: invalid attribute
│ 
│ Value cannot contain newlines in environment variables
*/



# --------- provider configuration use tfe variables ---------

# also similar to kubeconfig, but use tfe variable instead
# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = "docker-desktop" 
# }



# data "kubernetes_namespace" "default" {
#   metadata {
#     name = "default"
#   }
# }
# output "namespace" {
#   value       = data.kubernetes_namespace.default.metadata[0].name
#   description = "Default Kubernetes namespace"
# }

output "k8s_host" {
  value       = local.k8s_credential.host
  description = "Kubernetes host"
}

# Note. tfe variable not available in local mode; plan in remote mode to check the value
output "k8s_credential" {
  value     = var.k8s_credential
  sensitive = true
}
output "client_cert" {
  value     = var.k8s_credential_client_certificate
  sensitive = true
}
output "client_key" {
  value     = var.k8s_credential_client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = var.k8s_credential_cluster_ca_certificate
  sensitive = true
}
