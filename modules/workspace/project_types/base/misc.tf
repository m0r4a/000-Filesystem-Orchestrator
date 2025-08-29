terraform {
  required_version = ">= 1.6.0"
}

variable "project_path" {
  description = "The project path"
  type        = string
}

variable "create_templates" {
  description = "Weather to create template files based on project type"
  type        = bool
  default     = true
}

# variable "project_metadata" {
#   description = "Pretty straightforward"
#   type        = any
# }

variable "template_vars" {
  description = "Template variables map"
  type        = map(string)
}

output "templates" {
  value = local.base_templates
}

output "project_dirs" {
  value = local.project_dirs
}
