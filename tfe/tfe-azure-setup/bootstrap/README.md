# Bootstrap Terraform

This directory contains the initial configuration for creating Terraform State storage infrastructure and OIDC authentication setup.

## Usage

### 1. Update Configuration

Before running, update the `ado_org_project` variable in `main.tf`:

```hcl
locals {
  ado_org_project = "your-org/your-project"  # UPDATE THIS
}
```

### 2. Initialize

```bash
cd bootstrap
terraform init
```

### 3. Review the plan

```bash
terraform plan
```

### 4. Apply the configuration

```bash
terraform apply
```

### 5. Get the output

```bash
terraform output
```

Save these values for later use:
- `storage_account_name` - Update in environment providers.tf and pipeline YAMLs
- `azure_ad_application_id` - Use for ADO Service Connection
- `service_connection_name` - sc-azure-oidc

### 6. Update Configuration Files

Replace `REPLACE_WITH_YOUR_STORAGE_ACCOUNT_NAME` in:
- `../environments/dev/providers.tf`
- `../environments/stg/providers.tf`
- `../environments/prod/providers.tf`
- `../azure-pipelines-dev.yml`
- `../azure-pipelines-stg.yml`
- `../azure-pipelines-prod.yml`

### 7. Create Azure DevOps Service Connection

In Azure DevOps:
1. Go to `Project Settings` -> `Service connections`
2. Create new service connection
3. Type: `Azure Resource Manager`
4. Authentication method: `Workload Identity federation (automatic)`
5. Service principal (application): Enter the `azure_ad_application_id` from terraform output
6. Subscription: Select your Azure subscription
7. Resource group: Enter the `resource_group_name` from terraform output
8. Service connection name: `sc-azure-oidc`

## Cleanup

To remove these resources:

```bash
terraform destroy
```

**Note**: This will remove the Service Principal and role assignments. You may need to manually clean up any remaining federated credentials in Azure AD.

## Notes

- This configuration only needs to be run once
- After creation, state files will be stored in the Azure Storage Account
- OIDC Federated Credentials are created for Dev environment
- Stg and Prod containers/credentials are commented out by default, uncomment when needed
- The Service Principal gets Contributor role on the subscription - adjust if needed