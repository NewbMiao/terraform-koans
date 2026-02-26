# Terraform Azure CI/CD Pipeline with OIDC

Enterprise-grade Terraform CI/CD pipeline supporting multi-environment (Dev/Stg/Prod) deployment with OIDC passwordless authentication.

## 🏗️ Architecture Overview

```
├── modules/              # Reusable modules
│   └── app_service/      # App Service module
├── environments/         # Environment configurations
│   ├── dev/             # Development environment
│   ├── stg/             # Staging environment
│   └── prod/            # Production environment
├── azure-pipelines-dev.yml    # Dev Pipeline
├── azure-pipelines-stg.yml    # Staging Pipeline
├── azure-pipelines-prod.yml   # Production Pipeline
├── bootstrap/            # Bootstrap infrastructure
│   ├── main.tf          # Main Terraform configuration
│   ├── providers.tf     # Provider configuration
│   ├── constants.tf     # Common constants
│   ├── oidc.tf          # OIDC configuration
│   ├── pipelines.tf     # Pipeline definitions
│   └── random.tf        # Random resources
└── init.sh              # Bootstrap setup guide
```

## 🚀 Quick Start

### Prerequisites

- Azure CLI
- Terraform CLI (>= 1.5.0)
- Azure DevOps account
- Azure subscription (free account can be used for testing)
- Git with SSH key configured

### Step 1: Run Bootstrap Setup Guide

```bash
./init.sh
```

This script will:
- Check and install Azure CLI and Azure DevOps extension
- Authenticate to Azure
- List existing resources
- Display setup instructions

### Step 2: Create Azure DevOps Organization

If you don't have one, create at: https://dev.azure.com/

### Step 3: Update Configuration

Edit `bootstrap/constants.tf`:
```hcl
locals {
  ado_org_name = "your-ado-org-name"  # Update this
  # ... other configuration
}
```

### Step 4: Set Up ADO Authentication

Choose one of the following methods:

**Option 1: Interactive Login (Recommended)**
```bash
az devops login --org https://dev.azure.com/YOUR_ORG
```

**Option 2: PAT Token**
1. Generate PAT at: https://dev.azure.com/YOUR_ORG/_usersSettings/tokens
2. Scopes: Full Access
3. Set environment variable:
   ```bash
   export AZURE_DEVOPS_EXT_PAT='your-pat-token'
   ```

### Step 5: Run Terraform Bootstrap

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

This will create:
- Azure DevOps Project
- Git Repository
- Resource Group
- Storage Account (with unique name)
- State Containers (dev, stg, prod)
- OIDC Configuration (Azure AD App, Service Principal, Federated Credentials)

**Important: Note the outputs!**

### Step 6: Set Up SSH Key

1. Generate SSH key (if you don't have one):
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   ```

2. Copy the public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. Add SSH key to Azure DevOps:
   - Go to: https://dev.azure.com/YOUR_ORG/_usersSettings/keys
   - Click "Add SSH public key"
   - Paste your public key
   - Give it a name (e.g., "Development Machine")

### Step 7: Push Code to Azure DevOps

```bash
# Initialize Git repository (if not already initialized)
git init

# Add all files
git add .

# Commit changes
git commit -m "Initial Terraform CI/CD setup"

# Add remote repository (using SSH)
git remote add origin git@ssh.dev.azure.com:v3/YOUR_ORG/YOUR_PROJECT/YOUR_PROJECT

# Push all branches and tags
git push -u origin --all
```

Replace:
- `YOUR_ORG` with your ADO organization name
- `YOUR_PROJECT` with your ADO project name

### Step 8: Create Pipelines in Azure DevOps

1. Go to: https://dev.azure.com/YOUR_ORG/YOUR_PROJECT/_build
2. Click "New Pipeline"
3. Select "Azure Repos Git"
4. Select your repository
5. Choose "Existing Azure Pipelines YAML file"
6. Select `azure-pipelines-dev.yml`
7. Click "Continue"
8. Click "Save"

Repeat for `azure-pipelines-stg.yml` and `azure-pipelines-prod.yml` (optional).

### Step 9: Configure Azure DevOps Resources

#### Create Environments

Go to `Pipelines` -> `Environments`, create:
- `env-dev` (no approval required)
- `env-stg` (add approval)
- `env-prod` (add approval)

#### Create Service Connection

Go to `Project Settings` -> `Service connections`:
- Name: `sc-azure-oidc`
- Authentication method: `Workload Identity federation (automatic)`
- Scope: Your Azure Subscription

#### Configure Pipeline Variables

Add variables to each pipeline:
- `mysql_admin_password` (secret variable, locked)

For Prod environment, also add:
- `mysql_subnet_id` (MySQL private network subnet ID)
- `mysql_private_dns_zone_id` (MySQL Private DNS Zone ID)

## 📦 Environments

| Environment | Trigger | Approval | SKU | Description |
|-------------|---------|----------|-----|-------------|
| **Dev** | push to `develop` branch | ❌ | B1 / B_Standard_B1s | Development, auto-deploy |
| **Staging** | push to `main` branch | ✅ | P1v3 / B_Standard_B2s | Staging, requires approval |
| **Production** | Manual run | ✅ | P2v3 / B_Standard_B4ms | Production, manual trigger + approval |

## 🔒 Security Features

### OIDC Authentication
- Complete passwordless authentication
- Separate Federated Credential per environment
- Workload Identity Federation
- No secrets to manage

### Environment Isolation
- Separate Resource Groups
- Separate State containers
- Separate configuration parameters

### Production Enhancements
- Mandatory private networking
- Password length validation (≥24 chars)
- Manual trigger only
- Mandatory approval process

## 🧪 Free Account Limitations

Azure free account comes with one Subscription by default. Enterprise best practice is to use separate subscriptions for each environment, but with a free account, we use **Resource Groups** as the isolation boundary:

- `rg-dev-tf` - Development environment resources
- `rg-stg-tf` - Staging environment resources
- `rg-prod-tf` - Production environment resources

This approach maximizes the free account's $200 credit while maintaining good environment isolation.

## 📝 Workflow

```
Code changes → Push to branch
    ↓
┌─────────────┬─────────────┬─────────────┐
│  develop    │    main     │   Manual    │
└─────────────┴─────────────┴─────────────┘
    ↓            ↓            ↓
  Dev Auto    Stg Plan    Prod Plan
  Deploy     → Approve →  → Approve →
              Apply        Apply
```

## 🔧 Troubleshooting

### Terraform Init Fails
- Check if Storage Account Name is correctly replaced
- Confirm OIDC is configured
- Verify Service Connection configuration

### Pipeline Authentication Fails
- Confirm OIDC Federated Credential is created
- Check if ADO org/project name is correct
- Verify Azure AD app ID permissions

### Git Push Fails
- Verify SSH key is added to Azure DevOps
- Check SSH key permissions: `chmod 600 ~/.ssh/id_ed25519`
- Test SSH connection: `ssh -T git@ssh.dev.azure.com`

### Prod Deployment Fails
- Confirm `mysql_subnet_id` and `mysql_private_dns_zone_id` are configured
- Check if password length is ≥24 characters
- Verify Environment approval is configured

## 📚 References

- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure DevOps OIDC Authentication](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops)
- [Workload Identity Federation](https://learn.microsoft.com/en-us/entra/identity/workload-identity-federation/)
- [Azure DevOps SSH Keys](https://learn.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate)

## 📄 License

This project is for learning and reference purposes only.