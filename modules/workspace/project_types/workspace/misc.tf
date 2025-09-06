variable "workspace_config" {
  description = "Map of projects of this type"
  type = object({
    environment      = string
    create_templates = bool
    common           = bool
    template_vars    = map(string)
    extra_dirs       = map(string)
    created_by       = string
    tags             = map(string)
  })
}

locals {
  prefixed_templates = { for k, v in local.workspace_templates : "workspace-${k}" => v }
}

variable "workspace_path" {
  description = "Base path where the workspace will be created"
  type        = string
}

output "templates" {
  value = local.prefixed_templates
}

output "project_dirs" {
  value = local.workspace_dirs
}
