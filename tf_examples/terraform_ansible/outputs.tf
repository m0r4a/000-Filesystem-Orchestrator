output "project_name" {
  description = "Project name used"
  value       = module.example.project_name
}

output "workspace_path" {
  description = "Full path of the created workspace"
  value       = module.example.workspace_path
}


output "directories_created" {
  description = "List of created directories in the workspace"
  value       = module.example.directories_created
}

output "metadata_file_path" {
  description = "Path to the workspace metadata"
  value       = module.example.metadata_file_path
}

output "template_files_created" {
  description = "Template files created"
  value       = module.example.template_files_created
}
