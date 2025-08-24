locals {
  available_modules = {
    example   = module.example_project
    terraform = module.terraform_project
    ansible   = module.ansible_project
  }
}

module "common" {
  count            = var.common == true ? 1 : 0
  source           = "./project_types/common"
  project_path     = local.project_path
  create_templates = var.create_templates
  project_metadata = local.project_metadata
  template_vars = var.template_vars
}

module "workspace" {
  source           = "./project_types/workspace"
  workspace_path   = var.workspace_path
  create_templates = var.create_templates
  project_metadata = local.project_metadata
  template_vars = var.template_vars
}

module "example_project" {
  count            = var.project_type == "example" ? 1 : 0
  source           = "./project_types/example"
  project_path     = local.project_path
  create_templates = var.create_templates
  project_metadata = local.project_metadata
  template_vars = var.template_vars
}

module "terraform_project" {
  count            = var.project_type == "terraform" ? 1 : 0
  source           = "./project_types/terraform"
  project_path     = local.project_path
  create_templates = var.create_templates
  project_metadata = local.project_metadata
  template_vars = var.template_vars
}

module "ansible_project" {
  count            = var.project_type == "ansible" ? 1 : 0
  source           = "./project_types/ansible"
  project_path     = local.project_path
  create_templates = var.create_templates
  project_metadata = local.project_metadata
  template_vars = var.template_vars
}

locals {
  selected_module = one([
    for module_name, module_instance in local.available_modules :
    module_instance[0]
    if var.project_type == module_name && length(module_instance) > 0
  ])

  common_module = var.common == true && length(module.common) > 0 ? module.common[0] : null

  # Merge templates: workspace + common (if enabled) + selected type
  template_files = merge(
    var.workspace_master == true ? module.workspace.templates : {},
    local.common_module != null ? local.common_module.templates : {},
    local.selected_module != null ? local.selected_module.templates : {}
  )

  # Concatenate project dirs: workspace + common (if enabled) + selected type
  project_dirs = concat(
    var.workspace_master == true ? module.workspace.project_dirs : [],
    local.common_module != null ? local.common_module.project_dirs : [],
    local.selected_module != null ? local.selected_module.project_dirs : []
  )
}
