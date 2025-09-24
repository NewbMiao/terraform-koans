# TFE OPA Policy

> Note. Read this first: https://developer.hashicorp.com/terraform/enterprise/policy-enforcement/define-policies/opa

## Tooling

Recommend install the OPA extension, there are many hany features help on developing OPA policy.

- VScode extension: https://marketplace.visualstudio.com/items?itemName=tsandall.opa

```shell
# install regal for lang server
go install github.com/open-policy-agent/regal@latest
```

```shell
# upadate in vscode setting
{
    # ...
    # "editor.formatOnSave": true,
    "opa.languageServers": ["regal"], # to use regal for lint and format
}
```
> Use `cmd+shift+M`(Mac) to check the rego syntax suggestions
> Use pre-commit hook to check regal lint

- Format(manually): `opa fmt . -w`
- Test(manually): `opa test . -v`

## Policy

By default, you can use `data.terraform.deny` to query again tf plan as validation, eg:

```rego
# alicloud-xxx.repo

package terraform

import input.plan as plan
import input.run as run # if require run infomations

deny contains msg if {
    plan.a == "a"
    plan.b == "b"
    # ...
    msg = "this msg will return if the all above conditions matched"
}
```

## Policy Test

```rego
# alicloud-xxx_test.repo

package terraform_test

import data.terraform # import the policy rules

test_xxx_deny if {
    terraform.deny with input.plan as {
        # ... tf plan deny case, partial json is okay
    }
}
test_xxx_allow if {
    terraform.deny with input.plan as {
        # ... tf plan allow case, partial json is okay
    }
}
```

> To get **terraform plan json** for policy testing, you can download the `Download Sentinel mocks` from the succeed TFE plan, and check the `raw` json object of file `run-xxx-sentinel-mocks/mock-tfplan-v2.sentinel`
