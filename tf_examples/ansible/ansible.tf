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

  project_name   = "Ansible"
  workspace_path = "../../workdir_example"

  created_by   = "A nice user"
  description  = "This is just an ansible structure"
  project_type = "ansible"
  environment  = "dev"

  create_templates  = true

  extra_dirs = [
    "superprod_inv"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
