terraform {
  required_version = ">= 1.12"
}

variable "base_path" {
  description = "This is the root folder for the project"
  type        = string
}

variable "create_templates" {
  description = "Weather to create template files based on project type"
  type        = bool
  default     = true
}

variable "workspace_metadata" {
  description = "Pretty straightforward"
  type        = any
}

output "templates" {
  value = local.base_templates
}

output "project_dirs" {
  value = local.project_dirs
}
