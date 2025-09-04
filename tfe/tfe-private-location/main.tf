# pass via tfe terraform variable
variable "config_file" {
  description = "datadog private location config file content"
  type        = string
  sensitive   = true
}
resource "helm_release" "dd_pl" {
  name       = "dd-pl"
  version    = "0.17.12"
  repository = "https://helm.datadoghq.com"
  chart      = "synthetics-private-location"


  timeout          = 300
  namespace        = "tools"
  create_namespace = true
  force_update     = true
  values = [
    file("${path.root}/values.yaml"),
    jsonencode({ configFile = var.config_file })
  ]
  # setting values via `set` does not work
  # set {
  #   name  = "configFile"
  #   type  = "string"
  #   value = file("${path.root}/pl-config.json")
  # }
}
