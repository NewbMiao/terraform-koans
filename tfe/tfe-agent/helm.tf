resource "kubernetes_namespace" "namespaces" {
  metadata {
    name   = "tfc-agent"
    labels = {}
  }
}

resource "helm_release" "tfc_agent" {
  name  = "tfc-agent"
  chart = "./tfc-agent"

  timeout   = 120
  namespace = "tfc-agent"

  values = [file("./tfc-agent/values.yaml")]

  set_sensitive {
    name  = "Secret.tfcToken"
    value = var.tfc_agent_token # "sensitive value fetched from some secure source"
  }
  depends_on = [kubernetes_namespace.namespaces]
}
