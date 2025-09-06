module "workspace" {
  count = var.workspace != null ? 1 : 0

  source           = "./project_types/workspace"
  workspace_config = var.workspace
  workspace_path   = local.suffix_workspace_path
}

module "example" {
  count = contains(keys(local.projects_by_type), "example") ? 1 : 0

  source  = "./project_types/example"
  project = local.projects_by_type["example"]
}

module "base" {
  count = contains(keys(local.projects_by_type), "base") ? 1 : 0

  source  = "./project_types/base"
  project = local.projects_by_type["base"]
}

module "terraform_project" {
  count = contains(keys(local.projects_by_type), "terraform") ? 1 : 0

  source  = "./project_types/terraform"
  project = local.projects_by_type["terraform"]
}

locals {
  projects_list = ["example", "base", "terraform"]

  available_projects = {
    "example"   = module.example
    "base"      = module.base
    "terraform" = module.terraform_project
    "workspace" = module.workspace
  }

  active_project_types = concat(
    [
      for project_type in keys(local.projects_by_type) : project_type
      if contains(keys(local.available_projects), project_type)
    ],
    var.workspace != null ? ["workspace"] : []
  )

  all_projects_outputs = [
    for project_name in local.active_project_types :
    local.available_projects[project_name][0]
    if contains(keys(local.available_projects), project_name) && length(local.available_projects[project_name]) > 0
  ]

  all_project_dirs = flatten([for m in local.all_projects_outputs : m.project_dirs])

  all_templates = merge([for m in local.all_projects_outputs : m.templates]...)
}
