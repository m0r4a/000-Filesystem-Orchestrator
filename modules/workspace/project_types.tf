# locals {
#   available_modules = {
#     base      = module.base
#     example   = module.example_project
#     terraform = module.terraform_project
#     ansible   = module.ansible_project
#   }
# }

module "base" {
  source   = "./project_types/base"
  for_each = local.projects_by_type.base
  
  project_path     = each.value.project_path
  create_templates = each.value.create_templates
#  project_metadata = local.projects_metadata[each.key]
  template_vars    = each.value.template_vars
}

# module "workspace" {
#   source           = "./project_types/workspace"
#   workspace_path   = var.workspace_path
#   create_templates = var.create_templates
#   project_metadata = local.project_metadata
#   template_vars    = var.template_vars
# }

locals {
  group_projects_by_type = {
    base      = { for name, config in local.resolved_projects : name => config if config.project_type == "base" }
  }

  selected_project_modules = merge(
    { for name, module_instance in module.base : name => module_instance },
  )
  
  projects_template_files = {
    for name, config in local.resolved_projects : name => merge(
    # templates del proyecto correcto
      try(local.selected_project_modules[name].templates, {})
    )
  }

  projects_base_dirs = {
    for name, config in local.resolved_projects : name => concat(
      # Directorios default
      module.project_defaults.project_dirs,
      # Directorios del tipo de proyecto específico
      try(local.selected_project_modules[name].project_dirs, [])
    )
  }

  projects_all_directories = {
    for name, config in local.resolved_projects : name => distinct(concat(
      local.projects_base_dirs[name],
      config.extra_dirs
    ))
  }

  projects_directory_paths = {
    for name, dirs in local.projects_all_directories : name => [
      for dir in dirs : "${local.resolved_projects[name].project_path}/${dir}"
    ]
  }

  all_template_files = flatten([for name, templates in local.projects_template_files : values(templates)])
}
