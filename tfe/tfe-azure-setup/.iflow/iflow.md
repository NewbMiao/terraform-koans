# iFlow Configuration

## Project Guidelines

### Terraform Error Handling
- Always check Terraform errors and fix them by default
- When encountering Terraform validation errors, immediately update the configuration to use the correct attributes and values
- Common Terraform AzureRM fixes:
  - Use `storage_account_id` instead of deprecated `storage_account_name`
  - Use `client_id` for `azuread_service_principal` instead of `application_id`
  - Use `application_id` for `azuread_application_federated_identity_credential` instead of `application_object_id`
  - Remove unsupported attributes like `allow_blob_public_access`
  - Use `geo_redundant_backup_enabled` with boolean values instead of `geo_redundant_backup` with strings