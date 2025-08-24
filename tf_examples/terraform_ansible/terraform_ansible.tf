terraform {
  required_version = ">= 1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

module "example_terraform" {
  source = "../../modules/workspace"

  project_name   = "Terraform"
  workspace_path = "../../workdir_example"

  created_by   = "A nice user"
  description  = "This is a classic example of a project that uses Terraform + Ansible"
  project_type = "terraform"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true

  extra_dirs = [
    "terraform_dir"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}

module "example_ansible" {
  source = "../../modules/workspace"

  project_name   = "Ansible"
  workspace_path = "../../workdir_example"

  created_by   = "A nice user"
  description  = "This is a classic example of a project that uses Terraform + Ansible"
  project_type = "ansible"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true

  extra_dirs = [
    "ansible_dir"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
