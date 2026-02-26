#!/bin/bash

# ========================================
# Bootstrap Setup Guide
# ========================================
# Purpose: Display setup instructions and list existing resources
# ========================================

set -e

# Check Azure CLI
if ! command -v az &> /dev/null; then
   echo "Installing Azure CLI..."
   brew install az
fi

# Check Azure DevOps extension
if ! az extension show --name azure-devops &> /dev/null; then
    echo "Installing Azure DevOps extension..."
    az extension add --name azure-devops --output none
    echo "✅ Azure DevOps extension installed"
    echo ""
fi

# Login check
if ! az account show &> /dev/null; then
    az login
fi

echo "✅ Logged in to Azure"
echo ""

# ========================================
# List Resources
# ========================================

echo "============================================"
echo "Existing Resources"
echo "============================================"
echo ""

echo "Resource Groups:"
az group list --query "[].{Name:name, Location:location}" --output table 2>/dev/null || echo "  No resource groups found"
echo ""

echo "Storage Accounts:"
az storage account list --query "[].{Name:name, ResourceGroup:resourceGroup, Location:location}" --output table 2>/dev/null || echo "  No storage accounts found"
echo ""

echo "Azure DevOps:"
if az devops project list &> /dev/null; then
    echo "Projects:"
    az devops project list --query "[].{Name:name, Visibility:visibility}" --output table 2>/dev/null || echo "  No projects found"
else
    echo "  Not authenticated to Azure DevOps"
    echo "  Login with: az devops login --org https://dev.azure.com/YOUR_ORG"
fi
echo ""

# ========================================
# Setup Instructions
# ========================================

echo "============================================"
echo "Setup Instructions"
echo "============================================"
echo ""
echo "1. Create Azure DevOps Organization"
echo "   Go to: https://dev.azure.com/"
echo ""
echo "2. Generate PAT Token"
echo "   Go to: https://dev.azure.com/YOUR_ORG/_usersSettings/tokens"
echo "   Scopes: Full Access"
echo ""
echo "3. Set PAT Token"
echo "   export AZURE_DEVOPS_EXT_PAT='your-token'"
echo "   Or save to bootstrap/.env"
echo ""
echo "4. Update bootstrap/constants.tf"
echo "   - ado_org_name: Set your ADO org name"
echo "   Note: Storage account name is auto-generated with random suffix"
echo ""
echo "5. Run Terraform"
echo "   cd bootstrap"
echo "   terraform init"
echo "   terraform apply"
echo ""
echo "Terraform will create:"
echo "   - ADO Project"
echo "   - Resource Group"
echo "   - Storage Account"
echo "   - State Containers"
echo "   - OIDC Configuration"
echo ""
echo "============================================"