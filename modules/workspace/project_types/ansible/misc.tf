terraform {
  required_version = ">= 1.12"
}

variable "project_path" {
  description = "The project path"
  type        = string
}

variable "create_templates" {
  description = "Weather to create template files based on project type"
  type        = bool
}

variable "project_metadata" {
  description = "Pretty straightforward"
  type        = any
}

output "templates" {
  value = local.templates
}

output "project_dirs" {
  value = local.project_dirs
}
