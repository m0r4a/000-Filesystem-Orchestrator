terraform {
  required_version = ">= 1.6.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

module "terraform_workspace" {
  source = "./modules/workspace"

  project_name     = "Terraform"
  workspace_master = true
  workspace_path   = "./testing"

  created_by   = "Mora"
  description  = "XYZ Infra"
  project_type = "terraform"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true
  common            = true

  extra_dirs = [
    "super_custom_dir"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}

module "ansible_workspace" {
  source = "./modules/workspace"

  project_name   = "Ansible"
  workspace_path = "./testing"

  created_by   = "Mora"
  description  = "Super useful paybooks"
  project_type = "ansible"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true
  common            = true

  extra_dirs = [
    "superprod_inv"
  ]

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}

module "testing" {
  source = "./modules/workspace"

  project_name   = "example"
  workspace_path = "./testing"

  created_by   = "Mora"
  description  = "Super useful paybooks"
  project_type = "example"
  environment  = "dev"

  terraform_version = ">= 1.5"
  create_templates  = true

  extra_dirs = [
    "superprod_inv"
  ]

  template_vars = {
    testvar = "test"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
