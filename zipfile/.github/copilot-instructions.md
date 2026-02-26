# AI Agent Instructions for Terraform Zip File Module

This module demonstrates Terraform patterns for handling zip file creation and Node.js dependency management. Here's what you need to know to work effectively with this codebase:

## Project Structure

- `main.tf` - Core zip file creation logic using the `archive_file` data source
- `build-dep.tf` - Node.js dependency management and layer creation
- `dep/` - Contains Node.js dependencies
  - `package.json` - Node.js dependencies specification
  - `nodejs/` - Directory for installed dependencies

## Key Concepts

### File Hashing and Caching
- Files are zipped with their MD5 hash in the filename (e.g., `file.{md5}.zip`)
- This pattern ensures cache invalidation when source files change
```hcl
locals {
  file_md5 = filemd5("${path.module}/file-to-zip")
}
```

### Node.js Dependency Management
- Dependencies are installed using a `null_resource` with local-exec provisioner
- Package installation is triggered only when `package.json` changes via MD5 hash
- Dependencies are installed with specific architecture targeting (x64)
```hcl
triggers = {
  package_json = filemd5("${path.module}/dep/package.json")
}
```

## Development Workflow

1. **Initialize the Project**
   ```bash
   terraform init
   ```

2. **Making Changes**
   - Update `file-to-zip` content directly
   - Modify `dep/package.json` for dependency changes
   - Changes to these files will automatically trigger new zip creation on next apply

3. **Apply Changes**
   ```bash
   terraform apply
   ```

## Common Patterns

### Archive Creation
- Use `data "archive_file"` for creating zip files
- Always specify `type = "zip"` and appropriate source/destination paths
- Include proper dependencies using `depends_on` when archives depend on other resources

### Dependency Management
- Place Node.js dependencies in the `dep/nodejs/` directory structure
- Use `local-exec` provisioner for npm commands
- Always include proper error handling and path management

## Provider Requirements

Required providers and versions are specified in `main.tf`:
- archive (~> 2.0)
- null (~> 3.0)
- local (~> 2.0)
- Terraform version >= 1.9.0

## Outputs

The module provides two key outputs:
- `zipfile_path` - Path to the generated content zip file
- `dep_zipfile_path` - Path to the generated dependencies zip file