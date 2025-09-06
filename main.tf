module "workspace" {
  source = "./modules/workspace"

  workspace_path = "./my-workspace"

  project_defaults = {
    template_vars = { global_var = "test_global_var" }
  }

  workspace = {}

  projects = {
    "example" = {
      project_type = "example"
      extra_dirs   = ["test_extra_dir"]
      description  = "test description"
      template_vars = {
        custom_var = "my_var_2lol"
      }
      tags = {
        test_tag = "webos"
      }
    }
    "terraform" = {
      project_type = "terraform"
    }
  }
}
