terraform {
  required_version = ">= 1.9.0"
}
locals {
  vpcs = {
    network1 = {
      acct_key = "acct_a"
      name     = "vpc-1"
      cidrs    = [1]
    }
    network2 = {
      acct_key = "acct_a"
      name     = "vpc-2"
      cidrs    = [2]
    }
    network3 = {
      acct_key = "acct_b"
      name     = "vpc-3"
      cidrs    = [3]
    }
  }

  # Grouping VPCs by account key
  grouped_networks_as_array = {
    for k, v in local.vpcs :
    # @tflint-ignore: terraform_deprecated_interpolation
    v.acct_key => { "${k}" = v }...
  }
  grouped_networks_as_object = {
    for k, v in local.grouped_networks_as_array :
    k => merge({}, v...)
  }
}

output "group_result_dynamic" {
  description = "Grouped networks by account key"
  value       = local.grouped_networks_as_object
}
