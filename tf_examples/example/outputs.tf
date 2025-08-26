output "workspace_path" {
  description = "Full path of the created workspace"
  value       = module.example_1.workspace_path
}

output "workspace_files" {
  description = "Thee of the created workspace"
  value       = module.example_1.workspace_files
}

output "example_1_project_name" {
  description = "Project name used"
  value       = module.example_1.project_name
}

output "example_2_project_name" {
  description = "Project name used"
  value       = module.example_2.project_name
}
