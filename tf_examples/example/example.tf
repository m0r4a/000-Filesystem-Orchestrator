terraform {
  required_version = ">= 1.6.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
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
  version_control = true

  extra_dirs = [
    "docs",
  ]

  template_vars = {
    custom_var = "for your templates"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
