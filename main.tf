module "workspace" {
  source = "./modules/workspace"
  
  workspace_path   = "./workdir_example/my-workspace"

  project_defaults = {
    template_vars = {global_var = "test_global_var"}
  }

  workspace = {}

  projects = {
    "terraform 1" = {
      project_type  = "terraform"
      description = "test"
      template_vars = {
        custom_var = "my_var_2lol"
      }
    }
    "terraform" = {
      project_type = "terraform"
      description = "test"
    }
  }
}
