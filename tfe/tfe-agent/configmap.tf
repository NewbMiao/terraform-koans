locals {
  agent_configs = {
    scripts  = fileset(path.root, "scripts/**/*")
    policies = fileset(path.root, "policies/**/*.rego")
  }

  script_config_hash = sha1(join("", [for f in local.agent_configs.scripts : file("${path.root}/${f}")]))
  policy_config_hash = sha1(join("", [for f in local.agent_configs.policies : file("${path.root}/${f}")]))
}


resource "kubernetes_config_map" "agent_config" {
  for_each = local.agent_configs
  metadata {
    name      = "agent-${each.key}"
    namespace = kubernetes_namespace.namespaces.metadata[0].name
  }
  immutable = false
  data = {
    for key, value in each.value :
    replace(value, "${each.key}/", "") => file("${path.root}/${value}")
  }
  depends_on = [kubernetes_namespace.namespaces]
}
