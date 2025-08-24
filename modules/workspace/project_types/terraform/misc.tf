terraform {
  required_version = ">= 1.12"
}

variable "workspace_path" {
  description = "The workspace path"
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
  value = local.templates
}

output "project_dirs" {
  value = local.project_dirs
}
