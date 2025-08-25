locals {
  project_name_normalized = replace(lower(var.project_name), "/[^a-z0-9/]", "-")

  project_path = "${var.workspace_path}/${local.project_name_normalized}"

  project_metadata = {
    meta_project_name   = var.project_name
    meta_workspace_path = var.workspace_path

    meta_created_by = var.created_by
    meta_created_at = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())

    meta_project_type = var.project_type
    meta_environment  = var.environment

    meta_description       = var.description
    meta_tags         = var.tags

    meta_workspace_module = {
      version = "0.0.2"
      source  = path.module
    }
  }

  # project_dirs is on project_types
  all_directories = distinct(concat(local.project_dirs, var.extra_dirs))

  directory_paths = [for dir in local.all_directories : "${local.project_path}/${dir}"]
}
