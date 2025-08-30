variable "projects" {
  description = "Map of projects of this type"
  type = map(object({
    project_name            = string
    project_name_normalized = string
    project_path           = string
    project_type           = string
    description            = string
    create_templates       = bool
    common                 = bool
    extra_dirs             = list(string)
    template_vars          = map(string)
    tags                   = map(string)
  }))
}

output "templates" {
  value = local.templates
}

output "project_dirs" {
  value = local.project_dirs
}
