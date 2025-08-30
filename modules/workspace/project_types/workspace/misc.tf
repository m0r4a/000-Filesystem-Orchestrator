variable "workspace_config" {
  description = "Map of projects of this type"
  type = object({
    environment = string
    create_templates = bool
    common = bool
    template_vars = map(string)
    extra_dirs = map(string)
    created_by = string
    tags = map(string)
  })
}

variable "workspace_path" {
  description = "Base path where the workspace will be created"
  type        = string
}

output "workspace_templates" {
  value = local.workspace_templates
}

output "project_dirs" {
  value = local.workspace_dirs
}
