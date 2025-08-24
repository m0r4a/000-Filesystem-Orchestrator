# Outputs for ${meta_project_name}

output "project_info" {
  description = "Project information"
  value = {
    name        = var.project_name
    environment = var.environment
  }
}
