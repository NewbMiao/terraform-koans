# Terraform Azure CI/CD Pipeline with OIDC

Enterprise-grade Terraform CI/CD pipeline supporting multi-environment (Dev/Stg/Prod) deployment with OIDC passwordless authentication.

## 🏗️ Architecture Overview

```
├── modules/              # Reusable modules
│   └── app_service/  # App Service + MySQL module
├── environments/         # Environment configurations
│   ├── dev/             # Development environment
│   ├── stg/             # Staging environment
│   └── prod/            # Production environment
├── azure-pipelines-dev.yml    # Dev Pipeline
├── azure-pipelines-stg.yml    # Staging Pipeline
├── azure-pipelines-prod.yml   # Production Pipeline
├── bootstrap/            # Bootstrap infrastructure
│   ├── main.tf          # Create state storage
│   └── providers.tf     # Provider configuration
└── init.sh              # Bootstrap script (legacy)
```

## 🚀 Quick Start

### Prerequisites

- Azure CLI
- Terraform CLI (>= 1.5.0)
- Azure DevOps account
- Azure subscription (free account can be used for testing)

### Step 1: Local Environment Setup

#### Install Tools

```bash
# Install Azure CLI
# macOS
brew install azure-cli

# Linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Terraform
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

#### VS Code Extensions

- HashiCorp Terraform
- Azure Account (optional)

### Step 2: Authenticate to Azure

```bash
az login
az account show
```

Confirm you're pointing to your free trial subscription ("Azure subscription 1" or "Free Trial").

### Step 3: Run Bootstrap Terraform

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

This will create:
- Resource Group: `rg-terraform-state`
- Storage Account: `tfstatebootstrap`
- State container: `tfstate-dev`

**Important: Note the `storage_account_name` output!**

### Step 4: Replace Placeholders

Search for `REPLACE_WITH_YOUR_STORAGE_ACCOUNT_NAME` in the following files and replace with the actual Storage Account Name:

- `environments/dev/providers.tf`
- `environments/stg/providers.tf`
- `environments/prod/providers.tf`
- `azure-pipelines-dev.yml`
- `azure-pipelines-stg.yml`
- `azure-pipelines-prod.yml`

### Step 5: Local Test (Optional)

```bash
cd environments/dev

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply configuration (first time)
terraform apply
```

### Step 6: Push to Azure DevOps

```bash
# Initialize Git repository
git init
git add .
git commit -m "Initial Terraform CI/CD setup"

# Add remote repository
git remote add origin <your-ado-repo-url>
git push -u origin main
```

### Step 7: Azure DevOps Configuration

#### 1. Create Environments

Go to `Pipelines` -> `Environments`, create:
- `env-dev` (no approval required)
- `env-stg` (add approval)
- `env-prod` (add approval)

#### 2. Create Service Connection

Go to `Project Settings` -> `Service connections`:
- Name: `sc-azure-oidc`
- Authentication method: `Workload Identity federation (automatic)`
- Scope: Your Azure Subscription

#### 3. Create Pipelines

Create separate pipelines for each YAML file:
- `azure-pipelines-dev.yml` (Dev Pipeline)
- `azure-pipelines-stg.yml` (Staging Pipeline)
- `azure-pipelines-prod.yml` (Production Pipeline)

#### 4. Configure Pipeline Variables

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

### Environment Isolation
- Separate Resource Groups
- Separate State containers
- Separate configuration parameters

### Production Enhancements
- Mandatory private networking (MySQL)
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
- Confirm `use_oidc = true` is configured
- Verify Service Connection configuration

### Pipeline Authentication Fails
- Confirm OIDC Federated Credential is created
- Check if ADO org/project name is correct
- Verify Azure AD app ID permissions

### Prod Deployment Fails
- Confirm `mysql_subnet_id` and `mysql_private_dns_zone_id` are configured
- Check if password length is ≥24 characters
- Verify Environment approval is configured

## 📚 References

- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure DevOps OIDC Authentication](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops)
- [Workload Identity Federation](https://learn.microsoft.com/en-us/entra/identity/workload-identity-federation/)

## 📄 License

This project is for learning and reference purposes only.