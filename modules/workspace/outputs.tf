output "workspace_path" {
  description = "Full path of the created workspace"
  value       = local.workspace_path
}

output "workspace_name" {
  description = "Workspace name used"
  value       = local.workspace_name_normalized
}

output "directories_created" {
  description = "List of created directories in the workspace"
  value       = local.directory_paths
}

output "metadata" {
  description = "Workspace metadata"
  value       = local.workspace_metadata
  sensitive   = false
}

output "metadata_file_path" {
  description = "Path to the workspace metadata"
  value       = "${local.workspace_path}/.metadata.json"
}

output "template_files_created" {
  description = "Template files created"
  value       = { for k, v in local.template_files : k => v.path }
}

output "workspace_info" {
  description = "Full workspace info"
  value = {
    name         = var.workspace_name
    path         = local.workspace_path
    project_type = var.project_type
    environment  = var.environment
    directories  = length(local.directory_paths)
    files        = length(local.template_files)
  }
}
