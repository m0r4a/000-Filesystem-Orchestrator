locals {
  available_modules = {
    example   = module.example_project
    terraform = module.terraform_project
    ansible   = module.ansible_project
  }
}

module "base_project" {
  source = "./project_types/base"

  base_path          = var.base_path
  create_templates   = var.create_templates
  workspace_metadata = local.workspace_metadata
}

module "example_project" {
  count  = var.project_type == "example" ? 1 : 0
  source = "./project_types/example"

  workspace_path     = local.workspace_path
  create_templates   = var.create_templates
  workspace_metadata = local.workspace_metadata
  extra_vars         = var.extra_vars
}

module "terraform_project" {
  count  = var.project_type == "terraform" ? 1 : 0
  source = "./project_types/terraform"

  workspace_path     = local.workspace_path
  create_templates   = var.create_templates
  workspace_metadata = local.workspace_metadata
}

module "ansible_project" {
  count  = var.project_type == "ansible" ? 1 : 0
  source = "./project_types/ansible"

  workspace_path     = local.workspace_path
  create_templates   = var.create_templates
  workspace_metadata = local.workspace_metadata
}


locals {
  selected_module = one([
    for module_name, module_instance in local.available_modules :
    module_instance[0]
    if var.project_type == module_name && length(module_instance) > 0
  ])

  # This just merges the base + selected type of project
  template_files = merge(
    module.base_project.templates,
    local.selected_module != null ? local.selected_module.templates : {}
  )

  project_dirs = concat(
    module.base_project.project_dirs,
    local.selected_module != null ? local.selected_module.project_dirs : []
  )
}
