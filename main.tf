module "unified_workspace" {
  source = "./modules/workspace"
  
  workspace_path   = "./workdir_example/my-workspace"

  project_defaults = {}

  workspace = {}

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
      create_templates = false
    }
  }
}
