package terraform

import rego.v1

import input as plan

deny contains msg if {
	resource := plan.resource_changes[_]
	resource.type == "local_file"
	action := resource.change.actions[_]
	action == "create"
	filename := resource.change.after.filename
	forbidden_prefix(filename)
	msg := sprintf(
		"Violation: Resource '%v' creates a file '%v' which is not allowed to start with 'secret'.",
		[resource.name, filename],
	)
}

forbidden_prefix(filename) if {
	startswith(filename, "secret")
}

forbidden_prefix(filename) if {
	startswith(filename, "./secret")
}
