# Bootstrap Terraform

This directory contains the initial configuration for creating:
- Azure DevOps Project and Git Repository
- Terraform State storage infrastructure
- OIDC authentication setup

## Architecture

```
bootstrap/
├── main.tf          # Main configuration (ADO resources, Azure resources)
├── providers.tf     # Provider configuration (azurerm, azuread, azuredevops)
├── constants.tf     # Common constants and configuration
├── oidc.tf          # OIDC/Federated Identity Credentials
├── pipelines.tf     # Pipeline definitions (commented out by default)
└── random.tf        # Random resources for unique naming
```

## Prerequisites

- Azure CLI installed and authenticated
- Azure DevOps organization created
- PAT token or interactive login to Azure DevOps

## Usage

### 1. Run Setup Guide

```bash
cd ..
./init.sh
```

This will:
- Check and install Azure CLI and Azure DevOps extension
- Authenticate to Azure
- List existing resources
- Display setup instructions

### 2. Update Configuration

Edit `constants.tf`:

```hcl
locals {
  ado_org_name = "your-ado-org-name"  # UPDATE THIS
  # ... other configuration
}
```

### 3. Set Up ADO Authentication

Choose one method:

**Interactive Login:**
```bash
az devops login --org https://dev.azure.com/YOUR_ORG
```

**PAT Token:**
```bash
export AZURE_DEVOPS_EXT_PAT='your-pat-token'
```

### 4. Initialize Terraform

```bash
cd bootstrap
terraform init
```

### 5. Review the plan

```bash
terraform plan
```

### 6. Apply the configuration

```bash
terraform apply
```

This will create:
- Azure DevOps Project
- Git Repository
- Resource Group
- Storage Account (with unique name)
- State Containers (dev, stg, prod)
- Azure AD Application
- Service Principal
- Role Assignment
- OIDC Federated Credentials (dev environment)

### 7. Get the output

```bash
terraform output
```

Save these values for later use:
- `storage_account_name` - Already configured in environments
- `azure_ad_application_id` - Use for ADO Service Connection
- `service_connection_name` - sc-azure-oidc
- `ado_project_id` - ADO Project ID
- `git_repository_id` - Git Repository ID

### 8. Set Up SSH Key

1. Generate SSH key:
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   ```

2. Copy public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. Add to Azure DevOps:
   - Go to: https://dev.azure.com/YOUR_ORG/_usersSettings/keys
   - Click "Add SSH public key"
   - Paste your public key

### 9. Push Code to Azure DevOps

```bash
cd ..

# Initialize Git repository
git init
git add .
git commit -m "Initial Terraform CI/CD setup"

# Add remote repository (using SSH)
git remote add origin git@ssh.dev.azure.com:v3/YOUR_ORG/YOUR_PROJECT/YOUR_PROJECT

# Push all branches
git push -u origin --all
```

Replace:
- `YOUR_ORG` with your ADO organization name
- `YOUR_PROJECT` with your ADO project name

### 10. Create Azure DevOps Service Connection

In Azure DevOps:
1. Go to `Project Settings` -> `Service connections`
2. Create new service connection
3. Type: `Azure Resource Manager`
4. Authentication method: `Workload Identity federation (automatic)`
5. Service principal (application): Enter the `azure_ad_application_id` from terraform output
6. Subscription: Select your Azure subscription
7. Service connection name: `sc-azure-oidc`

### 11. Create Pipelines

In Azure DevOps:
1. Go to `Pipelines` -> `Create Pipeline`
2. Select `Azure Repos Git`
3. Select your repository
4. Choose `Existing Azure Pipelines YAML file`
5. Select `azure-pipelines-dev.yml`
6. Click `Continue`
7. Click `Save`

Repeat for `azure-pipelines-stg.yml` and `azure-pipelines-prod.yml` (optional).

### 12. Create Environments

Go to `Pipelines` -> `Environments`, create:
- `env-dev` (no approval required)
- `env-stg` (add approval)
- `env-prod` (add approval)

## Cleanup

To remove these resources:

```bash
terraform destroy
```

**Note**: This will remove:
- Azure DevOps Project and Repository
- Resource Group
- Storage Account
- Azure AD Application and Service Principal
- Role Assignment
- OIDC Federated Credentials

**Warning**: Make sure to backup any important data before running destroy.

## Notes

- This configuration only needs to be run once
- After creation, state files will be stored in the Azure Storage Account
- Storage Account name is auto-generated with random suffix for uniqueness
- OIDC Federated Credentials are created for Dev environment
- Stg and Prod containers/credentials are commented out by default, uncomment when needed
- The Service Principal gets Contributor role on the subscription - adjust if needed
- Pipeline creation is commented out in `pipelines.tf` - uncomment after pushing YAML files to repository

## Troubleshooting

### Storage Account Name Conflict

If you get "StorageAccountAlreadyTaken" error, the random suffix will automatically generate a new unique name.

### Pipeline Creation Fails

If you uncommented pipeline resources and get errors, ensure:
1. YAML files exist in the repository
2. YAML files are pushed to the correct branch
3. Repository is not empty

### ADO Authentication Fails

- Ensure you've run `az devops login` or set `AZURE_DEVOPS_EXT_PAT`
- Verify your ADO organization name is correct
- Check that you have permissions to create projects