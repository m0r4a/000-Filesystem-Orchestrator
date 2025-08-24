# ${meta_project_name}

## TODO: Improve this

${meta_description != "" ? meta_description : "Generated workspace for ${meta_project_type} project"}

## Workspace Information

- **Created By**: ${meta_created_by != "" ? meta_created_by : "Terraform Workspace Module"}
- **Environment**: ${meta_environment}
- **Project Type**: ${meta_project_type}

## Getting Started

1. Initialize Terraform: `terraform init`
2. Plan deployment: `terraform plan`
3. Apply changes: `terraform apply`

## Metadata

This workspace was generated using the Terraform Workspace Module.
Metadata is stored in `(project_name)/.metadata.json`.
