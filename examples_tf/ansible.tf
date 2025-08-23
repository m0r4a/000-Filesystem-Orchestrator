terraform {
  required_version = ">= 1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

module "ansible_workspace" {
  source = "./modules/workspace"

  workspace_name = "Ansible"
  base_path      = "../example_workdir"

  created_by   = "A nice user"
  description  = "This is just an ansible structure"
  project_type = "ansible"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true

  extra_dirs = [
    "superprod_inv"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
