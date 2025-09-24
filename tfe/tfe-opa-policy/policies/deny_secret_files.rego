package terraform

import input.plan as plan
import rego.v1

deny contains msg if {
	some resource in plan.resource_changes
	resource.type == "local_file"
	some action in resource.change.actions
	action == "create"
	filename := resource.change.after.filename
	contains(filename, "secret")
	msg := sprintf(
		"Violation: Resource '%v' creates a file '%v' which is not allowed to start with 'secret'.",
		[resource.name, filename],
	)
}
