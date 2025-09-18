# invalid alicloud provider check
package terraform

deny contains msg if {
	some resource in input.resource_changes
	resource.provider_name == "registry.terraform.io/hashicorp/alicloud"
	msg = sprintf(
		"Resource '%s' uses invalid provider 'hashicorp/alicloud'. Only 'aliyun/alicloud' is allowed.",
		[resource.address],
	)
}

deny contains msg if {
	some i
	input.configuration.provider_config[i].full_name == "registry.terraform.io/hashicorp/alicloud"
	msg = sprintf(
		"Provider_config '%s' uses invalid provider 'hashicorp/alicloud'. Only 'aliyun/alicloud' is allowed.",
		[i],
	)
}
