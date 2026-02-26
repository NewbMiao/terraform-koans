# ========================================
# Azure DevOps Pipeline Resources
# ========================================
# Purpose: Create pipelines from YAML files
# Note: Pipeline creation requires YAML files to exist in the repository first
# ========================================

# Pipeline creation is commented out because:
# 1. The repository is created by Terraform but is empty
# 2. Pipeline YAML files need to be pushed to the repository first
# 3. After pushing YAML files, uncomment and run terraform apply

# Dev Environment Pipeline (uncomment after pushing azure-pipelines-dev.yml)
# resource "azuredevops_build_definition" "dev" {
#   project_id = azuredevops_project.this.id
#   name       = "Dev Pipeline"
#   path       = "\\"
#
#   repository {
#     repo_type   = "TfsGit"
#     repo_id     = azuredevops_git_repository.this.id
#     branch_name = azuredevops_git_repository.this.default_branch
#     yml_path    = "azure-pipelines-dev.yml"
#   }
# }

# Staging Environment Pipeline (uncomment after pushing azure-pipelines-stg.yml)
# resource "azuredevops_build_definition" "stg" {
#   project_id = azuredevops_project.this.id
#   name       = "Staging Pipeline"
#   path       = "\\"
#
#   repository {
#     repo_type   = "TfsGit"
#     repo_id     = azuredevops_git_repository.this.id
#     branch_name = azuredevops_git_repository.this.default_branch
#     yml_path    = "azure-pipelines-stg.yml"
#   }
# }

# Production Environment Pipeline (uncomment after pushing azure-pipelines-prod.yml)
# resource "azuredevops_build_definition" "prod" {
#   project_id = azuredevops_project.this.id
#   name       = "Production Pipeline"
#   path       = "\\"
#
#   repository {
#     repo_type   = "TfsGit"
#     repo_id     = azuredevops_git_repository.this.id
#     branch_name = azuredevops_git_repository.this.default_branch
#     yml_path    = "azure-pipelines-prod.yml"
#   }
# }

# ========================================
# Outputs
# ========================================

output "git_repository_id" {
  description = "Git Repository ID"
  value       = azuredevops_git_repository.this.id
}

output "git_repository_name" {
  description = "Git Repository Name"
  value       = azuredevops_git_repository.this.name
}

# Uncomment these outputs when pipelines are enabled
# output "dev_pipeline_id" {
#   description = "Dev Pipeline ID"
#   value       = azuredevops_build_definition.dev.id
# }
