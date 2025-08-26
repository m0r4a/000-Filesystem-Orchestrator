terraform {
  required_version = ">= 1.6.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

module "api_service" {
  source = "./modules/workspace"

  project_name     = "user-service"
  project_type     = "base"
  create_templates = true

  template_vars = {
    service_name  = "user-management-api"
    service_port  = "8080"
    database_name = "users"
    redis_enabled = "true"
  }

  extra_dirs = [
    "config",
    "scripts/deployment",
    "docs/api"
  ]

  tags = {
    Service = "user-management"
    Tier    = "backend"
  }
}
