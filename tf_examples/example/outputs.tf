output "project_name" {
  description = "Project name used"
  value       = module.example_1.project_name
}

output "workspace_path" {
  description = "Full path of the created workspace"
  value       = module.example_1.workspace_path
}


output "directories_created" {
  description = "List of created directories in the workspace"
  value       = module.example_1.directories_created
}

output "metadata_file_path" {
  description = "Path to the workspace metadata"
  value       = module.example_1.metadata_file_path
}

output "template_files_created" {
  description = "Template files created"
  value       = module.example_1.template_files_created
}
