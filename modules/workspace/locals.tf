resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

locals {
  suffix_workspace_path = "${var.workspace_path}-${random_string.suffix.result}"

  projects_by_type = {
    for name, config in var.projects : config.project_type => {
      project_name     = replace(lower(name), "/[^a-z0-9/]", "-")
      project_path     = "${local.suffix_workspace_path}/${replace(lower(name), "/[^a-z0-9/]", "-")}"
      create_templates = coalesce(config.create_templates, var.project_defaults.create_templates)
      template_vars    = merge(var.project_defaults.template_vars, coalesce(config.template_vars, {}))
      extra_dirs       = coalesce(config.extra_dirs, var.project_defaults.extra_dirs)

      metadata = {
        meta_project_name = name
        meta_project_type = config.project_type
        meta_description  = config.description
        meta_tags         = merge(var.project_defaults.tags, coalesce(config.tags, {}))
      }
    }
  }

}
