# ${project_name}

## TODO: Improve this

${description != "" ? description : "Generated workspace for ${project_type} project"}

## Workspace Information

- **Creation date**: ${created_at}
- **Created By**: ${created_by != "" ? created_by : "Terraform Workspace Module"}
- **Environment**: ${environment}
- **Project Type**: ${project_type}

## Getting Started

1. Initialize Terraform: `terraform init`
2. Plan deployment: `terraform plan`
3. Apply changes: `terraform apply`

## Metadata

This workspace was generated using the Terraform Workspace Module.
Metadata is stored in `(project_name)/.metadata.json`.
