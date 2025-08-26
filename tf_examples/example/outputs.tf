output "workspace_path" {
  description = "Full path of the created workspace"
  value       = module.example_1.workspace_path
}

output "example_1_project_name" {
  description = "Project name used"
  value       = module.example_1.project_name
}

output "example_2_project_name" {
  description = "Project name used"
  value       = module.example_2.project_name
}

output "example_1_directories_created" {
  description = "List of created directories in the workspace"
  value       = module.example_1.directories_created
}

output "example_2_directories_created" {
  description = "List of created directories in the workspace"
  value       = module.example_2.directories_created
}

output "example_1_metadata_file_path" {
  description = "Path to the workspace metadata"
  value       = module.example_1.metadata_file_path
}

output "example_2_metadata_file_path" {
  description = "Path to the workspace metadata"
  value       = module.example_2.metadata_file_path
}

output "example_1_template_files_created" {
  description = "Template files created"
  value       = module.example_1.template_files_created
}

output "example_2_template_files_created" {
  description = "Template files created"
  value       = module.example_2.template_files_created
}
