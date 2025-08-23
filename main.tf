terraform {
  required_version = ">= 1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

module "terraform_workspace" {
  source = "./modules/workspace"

  workspace_name = "Terraform"
  base_path      = "./testing"

  created_by   = "Mora"
  description  = "Test project"
  project_type = "terraform"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true

  extra_dirs =[
    "test_dir"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}

module "ansible_workspace" {
  source = "./modules/workspace"

  workspace_name = "Ansible"
  base_path      = "./testing/"

  created_by   = "Mora"
  description  = "Test project"
  project_type = "base"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true

  extra_dirs =[
    "test_dir"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
