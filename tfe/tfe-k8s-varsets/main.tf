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
resource "tfe_variable" "k8s_credential" {
  key             = "k8s_credential"
  value           = jsonencode(local.k8s_credential)
  category        = "env"
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
provider "kubernetes" {
  client_certificate     = base64decode(local.k8s_credential.client_certificate)
  client_key             = base64decode(local.k8s_credential.client_key)
  cluster_ca_certificate = base64decode(local.k8s_credential.cluster_ca_certificate)
  host                   = local.k8s_credential.host # or use tfe env variable
}
# also similar to kubeconfig, but use tfe variable instead
# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = "docker-desktop" 
# }

# Note. tfe variable not available in local mode
output "k8s_host" {
  value       = local.k8s_credential.host
  description = "Kubernetes host"
}

data "kubernetes_namespace" "default" {
  metadata {
    name = "default"
  }
}
output "namespace" {
  value       = data.kubernetes_namespace.default.metadata[0].name
  description = "Default Kubernetes namespace"
}
