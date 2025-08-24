terraform {
  required_version = ">= 1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

module "example" {
  source = "../../modules/workspace"

  project_name   = "example_workspace"
  workspace_path = "../../workdir_example"


  created_by   = "A nice user"
  description  = "This works as a guideline for how you can implement a new project type"
  project_type = "example"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true
  common            = true
  workspace_master  = true

  extra_dirs = [
    "your_dir"
  ]

  extra_vars = {
    custom_var = "for your templates"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
