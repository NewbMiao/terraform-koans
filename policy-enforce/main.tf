# tflint-ignore: terraform_required_version
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.259.0"
    }
  }
}
provider "alicloud" {
  assume_role {}
}
data "alicloud_caller_identity" "current" {}

module "demo" {
  source = "./module-with-hasicorp-provider"

}
output "module_caller_identity" {
  value = module.demo.caller_identity
}
output "current_caller_identity" {
  value = data.alicloud_caller_identity.current
}
