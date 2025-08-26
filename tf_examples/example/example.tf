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
  project_type = "example"

  created_by   = "A nice user"
  description  = "This works as a guideline for how you can implement a new project type"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true
  common            = true
  workspace_master  = true
  version_control   = true

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
  project_type = "base"

  created_by   = "A nice user"
  description  = "This is another project"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true
  common            = true
  workspace_master  = true
  version_control   = true

  template_vars = {
    custom_var = "for your templates"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
