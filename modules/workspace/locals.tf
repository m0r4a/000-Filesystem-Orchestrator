locals {
  workspace_name_normalized = replace(lower(var.workspace_name), "/[^a-z0-9/]", "-")

  workspace_path = "${var.base_path}/${local.workspace_name_normalized}"

  workspace_metadata = {
    workspace_name = var.workspace_name
    workspace_path = local.workspace_path

    created_at = timestamp()
    created_by = var.created_by

    project_type = var.project_type
    environment  = var.environment
    tags         = var.tags

    terraform_version = var.terraform_version
    description       = var.description

    workspace_module = {
      version = "0.0.2"
      source  = path.module
    }
  }

  # project_dirs is on project_types
  all_directories = distinct(concat(local.project_dirs, var.extra_dirs))

  directory_paths = [for dir in local.all_directories : "${local.workspace_path}/${dir}"]
}
