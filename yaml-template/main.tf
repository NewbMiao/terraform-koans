
terraform {
  required_version = ">= 1.9.0"
}
locals {
  ns_role_mapping = {
    core-editor = {
      role     = "core-editor"
      ns       = ["core"]
      role_ref = "cluster-admin"
    }
    admin = {
      role     = "admin"
      ns       = ["*"]
      role_ref = "cluster-admin"
    }
  }
  ns_role_binding_flat = merge([
    for permission_key, permission in local.ns_role_mapping :
    {
      for ns in permission.ns :
      "${permission_key}_${ns}" => {
        role     = permission.role,
        role_ref = permission.role_ref,
        ns       = ns
      }
    }
  ]...)
}

output "namespace_role_binding" {
  value = local.ns_role_binding_flat

}
output "rendered_template_admin" {
  value = yamldecode(templatefile("${path.root}/ns-role-binding.tpl", {
    role     = local.ns_role_binding_flat["admin_*"].role
    role_ref = local.ns_role_binding_flat["admin_*"].role_ref
    ns       = local.ns_role_binding_flat["admin_*"].ns
  }))
}
output "rendered_template_core_editor" {
  value = yamldecode(templatefile("${path.root}/ns-role-binding.tpl", {
    role     = local.ns_role_binding_flat["core-editor_core"].role
    role_ref = local.ns_role_binding_flat["core-editor_core"].role_ref
    ns       = local.ns_role_binding_flat["core-editor_core"].ns
  }))
}
