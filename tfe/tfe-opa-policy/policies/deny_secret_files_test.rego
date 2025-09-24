package terraform_test

import data.terraform

test_deny_secret_file_deny if {
	some result in terraform.deny with input.plan as {"resource_changes": [{
		"address": "local_file.app_secret",
		"mode": "managed",
		"type": "local_file",
		"name": "app_secret",
		"provider_name": "registry.terraform.io/hashicorp/local",
		"change": {
			"actions": ["create"],
			"before": null,
			"after": {
				"content": "sensitive-info",
				"content_base64": null,
				"directory_permission": "0777",
				"file_permission": "0777",
				"filename": "./secret-credentials.txt",
				"sensitive_content": null,
				"source": null,
			},
		},
	}]}
	result == "Violation: Resource 'app_secret' creates a file './secret-credentials.txt' which is not allowed to start with 'secret'."
}

test_deny_secret_file_pass if {
	count(terraform.deny) == 0 with input.plan as {"resource_changes": [{
		"address": "local_file.user_data",
		"mode": "managed",
		"type": "local_file",
		"name": "user_data",
		"provider_name": "registry.terraform.io/hashicorp/local",
		"change": {
			"actions": ["create"],
			"before": null,
			"after": {
				"content": "This is user data.",
				"content_base64": null,
				"directory_permission": "0777",
				"file_permission": "0777",
				"filename": "./data.txt",
				"sensitive_content": null,
				"source": null,
			},
		},
	}]}
}
