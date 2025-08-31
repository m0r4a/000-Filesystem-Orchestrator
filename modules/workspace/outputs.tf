output "workspace_path" {
  description = "Full path of the created workspace"
   value       = local.suffix_workspace_path
}

output "project_names" {
  description = "Project name used"
   value       = keys(local.resolved_projects)
}

output "directories_created" {
  description = "List of created directories in the workspace"
  value       = local.all_project_dirs
}

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
#   value       = local.all_templates
# }

output "workspace_files" {
  description = "Tree of workspace files"
  value       = data.external.workspace_files.result
}
