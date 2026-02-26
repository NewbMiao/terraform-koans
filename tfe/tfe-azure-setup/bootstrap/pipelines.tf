# ========================================
# Azure DevOps Pipeline Resources
# ========================================
# Purpose: Create pipelines from YAML files
# ========================================

# Dev Environment Pipeline
resource "azuredevops_build_definition" "dev" {
  project_id = azuredevops_project.this.id
  name       = "Dev Pipeline"
  path       = "\\"

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.this.id
    branch_name = "refs/heads/main"
    yml_path    = "azure-pipelines-dev.yml"
  }
}

# Staging Environment Pipeline (commented out - uncomment when ready)
# resource "azuredevops_build_definition" "stg" {
#   project_id = azuredevops_project.this.id
#   name       = "Staging Pipeline"
#   path       = "\\"
#
#   repository {
#     repo_type   = "TfsGit"
#     repo_id     = azuredevops_git_repository.this.id
#     branch_name = "refs/heads/main"
#     yml_path    = "azure-pipelines-stg.yml"
#   }
# }

# Production Environment Pipeline (commented out - uncomment when ready)
# resource "azuredevops_build_definition" "prod" {
#   project_id = azuredevops_project.this.id
#   name       = "Production Pipeline"
#   path       = "\\"
#
#   repository {
#     repo_type   = "TfsGit"
#     repo_id     = azuredevops_git_repository.this.id
#     branch_name = "refs/heads/main"
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

output "dev_pipeline_id" {
  description = "Dev Pipeline ID"
  value       = azuredevops_build_definition.dev.id
}
