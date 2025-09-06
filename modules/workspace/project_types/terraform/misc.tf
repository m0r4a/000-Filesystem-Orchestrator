variable "project" {
  description = "This contains all the information needed for the project creation"
  type = object({
    project_name     = string
    project_path     = string
    create_templates = bool
    extra_dirs       = list(string)
    template_vars    = map(string)
    metadata = object({
      meta_project_name = string
      meta_project_type = string
      meta_description  = string
      meta_tags         = map(string)
    })
  })
}

locals {
  prefixed_templates = { for k, v in local.templates : "${var.project.project_name}-${k}" => v }

  final_project_dirs = flatten([
    [for dir in local.project_dirs : "${var.project.project_path}/${dir}"],
    [for extra in var.project.extra_dirs : "${var.project.project_path}/${extra}"]
  ])
}

output "templates" {
  value = local.prefixed_templates
}

output "project_dirs" {
  value = local.final_project_dirs
}
