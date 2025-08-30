# Outputs for smth

output "project_info" {
  description = "Project information"
  value = {
    name        = var.project_name
    environment = var.environment
  }
}
