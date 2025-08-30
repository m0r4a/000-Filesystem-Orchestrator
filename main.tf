module "unified_workspace" {
  source = "./modules/workspace"
  
  workspace_path   = "./workspaces/my-workspace"

  project_defaults = {}

  projects = {
    "example_project" = {
      project_type  = "example"
      description = "test"
      template_vars = {
        custom_var = "my_var"
      }
    }
    "example_project2" = {
      project_type  = "example"
      description = "test"
      template_vars = {
        custom_var = "my_var_2lol"
      }
    }
    "another_one_bites_the_dust" = {
      project_type = "terraform"
      description = "test"
    }
  }
}

output "variable" {
  value = module.unified_workspace.templates_temp
}
