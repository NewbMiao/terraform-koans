# tflint-ignore: terraform_required_version
# tflint-ignore: terraform_required_providers
data "alicloud_caller_identity" "module_caller_identity" {}
output "caller_identity" {
  value = data.alicloud_caller_identity.module_caller_identity
}
# tflint-ignore: terraform_required_providers
resource "alicloud_vpc" "name" {
  vpc_name   = "test-vpc"
  cidr_block = "10.0.0.0/20"
}
