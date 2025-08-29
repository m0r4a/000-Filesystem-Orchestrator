resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

locals {
  suffix_workspace_path = "${var.workspace_path}-${random_string.suffix.result}"

  resolved_projects = {
    for name, config in var.projects : name => {
      project_name            = name
      project_name_normalized = replace(lower(name), "/[^a-z0-9/]", "-")
      project_path           = "${local.suffix_workspace_path}/${replace(lower(name), "/[^a-z0-9/]", "-")}"
      project_type           = config.project_type
      description            = config.description
      environment            = coalesce(config.environment, var.project_defaults.environment)
      create_templates       = coalesce(config.create_templates, var.project_defaults.create_templates)
      common                 = coalesce(config.common, var.project_defaults.common)
      extra_dirs             = coalesce(config.extra_dirs, var.var.project_defaults.extra_dirs)
      template_vars          = merge(var.project_defaults.template_vars, coalesce(config.template_vars, {}))
      tags                   = merge(var.project_defaults.tags, coalesce(config.tags, {}))
    }
  }

 # project_dirs is on project_types
  all_directories = distinct(concat(local.project_dirs, var.extra_dirs))

  directory_paths = [for dir in local.all_directories : "${local.project_path}/${dir}"]
}
