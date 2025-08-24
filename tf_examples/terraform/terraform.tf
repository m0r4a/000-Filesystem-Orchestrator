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

  project_name   = "Terraform"
  workspace_path = "../../workdir_example"

  created_by   = "A nice user"
  description  = "Very basic terraform template"
  project_type = "terraform"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true

  extra_dirs = [
    "super_custom_dir"
  ]

  extra_vars = {
    custom_x = "y"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
