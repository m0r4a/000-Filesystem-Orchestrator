### Processing project data ###

locals {
  # Convert the map `local.resolved_projects` into a homogeneous list of objects.
  # Each element contains the project name, the project's declared type, and the full config.
  # Like this: [{ project_name = "x", project_type = "y", config = {...} }, ...]
  projects_list = [
    for name, config in local.resolved_projects : {
      project_name = name
      project_type = config.project_type
      config       = config
    }
  ]

  # Extract the project_type value from each item in `local.projects_list` and return
  # a list of unique types (removes duplicates with `distinct`).
  # Like this: ["example", "base"]
  project_types = distinct([
    for p in local.projects_list : p.project_type
  ])

  # Build a map with the project_type as key
  # Each value is a map of project_name => config for projects of that type.
  # The output is smth like this:
  # {
  #   "example" = {
  #     "projA" = { project_type = "example", ... }
  #   }
  #   "base" = {
  #     "projB" = { project_type = "base", ... }
  #   }
  # }
  projects_by_type = {
    for t in local.project_types : t => {
      for p in local.projects_list :
      p.project_name => p.config if p.project_type == t
    }
  }
}

### Creating the modules ###

module "example" {
  count = contains(keys(local.projects_by_type), "example") ? 1 : 0

  source   = "./project_types/example"
  projects = lookup(local.projects_by_type, "example", {})
}

module "workspace" {
  count = var.workspace != null ? 1 : 0

  source           = "./project_types/workspace"
  workspace_config = var.workspace
  workspace_path   = local.suffix_workspace_path
}

module "base" {
  count = contains(keys(local.projects_by_type), "base") ? 1 : 0

  source   = "./project_types/base"
  projects = lookup(local.projects_by_type, "base", {})
}

module "terraform_project" {
  count = contains(keys(local.projects_by_type), "terraform") ? 1 : 0

  source   = "./project_types/terraform"
  projects = lookup(local.projects_by_type, "terraform", {})
}

### Output aggregation ###

locals {
  available_modules = {
    "example"   = module.example
    "base"      = module.base
    "terraform" = module.terraform_project
  }

  # For each project type that exists in both projects_by_type and available_modules,
  # check if the module was created/instace-on/idk (count > 0) and return the first instance,
  # otherwise return null.
  active_modules = {
    for type in keys(local.projects_by_type) : type => (
      length(lookup(local.available_modules, type, [])) > 0 ?
      lookup(local.available_modules, type, [])[0] : null
    )
    if contains(keys(local.available_modules), type)
  }

  # It's important to have this two separated because a standard module output is a
  # map of maps with strings inside but workpace's module it's just a map[string]
  active_modules_with_workspace = merge(
    local.active_modules,
    length(module.workspace) > 0 ? { "workspace" = module.workspace[0] } : {}
  )
}

### Final output processing ###

# Finally I merge all the dirs and templates given by the instance
# of x or y module
locals {

  all_project_dirs = flatten([
    for type, module_instance in local.active_modules_with_workspace :
    module_instance != null ? module_instance.project_dirs : []
  ])

  # This processes the map of maps outputted by the modules and turn it
  # into a map[string], renaming each "children" of every map to:
  # parent_map-children_map fixing the issue of overlapping variables
  standard_project_templates = flatten([
    for type, module_instance in local.active_modules :
    module_instance != null ? flatten([
      for parent_key, parent_value in module_instance.templates :
        can(keys(parent_value)) ? [
          for child_key, child_value in parent_value : { key = "${parent_key}-${child_key}", value = child_value }
        ] : []
    ]) : []
  ])

  # Workspace_templates with it's simple structure
  workspace_templates = length(module.workspace) > 0 ? [
    for k, v in module.workspace[0].workspace_templates : { key = k, value = v }
  ] : []

  all_templates = concat(local.standard_project_templates, local.workspace_templates)

  final_templates = { for item in local.all_templates : item.key => item.value }
}
