terraform {
  required_version = ">= 1.6.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

module "example_1" {
  source = "../../modules/workspace"

  workspace_path = "../../workdir_example"
  project_name   = "example_workspace"
  project_type   = "example"

  created_by  = "A nice user"
  description = "This works as a guideline for how you can implement a new project type"
  environment = "dev"

  create_templates = true
  common           = true
  version_control  = true
  workspace_master = true

  extra_dirs = [
    "my_extra_dir",
  ]

  template_vars = {
    custom_var = "for your templates"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}

module "example_2" {
  source = "../../modules/workspace"

  workspace_path = "../../workdir_example"
  project_name   = "Terraform"
  project_type   = "terraform"

  created_by  = "A nice user"
  description = "This is another project"
  environment = "dev"

  create_templates = true
  common           = true
  version_control  = true

  template_vars = {
    custom_var = "for your templates"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
