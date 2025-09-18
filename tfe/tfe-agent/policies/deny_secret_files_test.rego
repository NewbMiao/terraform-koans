package terraform

test_deny_secret_file_deny if {
	deny with input as {
		"resource_changes": [
			{
				"address": "local_file.app_secret",
				"mode": "managed",
				"type": "local_file",
				"name": "app_secret",
				"provider_name": "registry.terraform.io/hashicorp/local",
				"change": {
					"actions": [
						"create"
					],
					"before": null,
					"after": {
						"content": "sensitive-info",
						"content_base64": null,
						"directory_permission": "0777",
						"file_permission": "0777",
						"filename": "./secret-credentials.txt",
						"sensitive_content": null,
						"source": null
					}
				}
			}
		]
	}
}

test_deny_secret_file_pass if {
	count(deny) == 0 with input as {
		"resource_changes": [
			{
				"address": "local_file.user_data",
				"mode": "managed",
				"type": "local_file",
				"name": "user_data",
				"provider_name": "registry.terraform.io/hashicorp/local",
				"change": {
					"actions": [
						"create"
					],
					"before": null,
					"after": {
						"content": "This is user data.",
						"content_base64": null,
						"directory_permission": "0777",
						"file_permission": "0777",
						"filename": "./data.txt",
						"sensitive_content": null,
						"source": null
					},
				}
			}
		]
	}
}
