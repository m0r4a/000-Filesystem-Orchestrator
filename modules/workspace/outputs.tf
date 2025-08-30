output "templates_temp" {
  value = local.templates_temp
}

# output "workspace_path" {
#   description = "Full path of the created workspace"
#   value       = var.workspace_path
# }

# output "project_name" {
#   description = "Project name used"
#   value       = local.project_name_normalized
# }

# output "directories_created" {
#   description = "List of created directories in the workspace"
#   value       = local.directory_paths
# }

# output "metadata" {
#   description = "Project metadata"
#   value       = local.project_metadata
#   sensitive   = false
# }

# output "metadata_file_path" {
#   description = "Path to the workspace metadata"
#   value       = "${local.project_path}/.metadata.json"
# }

# output "template_files_created" {
#   description = "Template files created"
#   value       = { for k, v in local.template_files : k => v.path }
# }

# output "workspace_files" {
#   description = "Tree of workspace files"
#   value       = var.workspace_master ? data.external.workspace_files[0].result : null
# }
