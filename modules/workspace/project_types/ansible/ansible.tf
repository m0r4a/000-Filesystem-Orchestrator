variable "workspace_path" {
  description = "The workspace path"
  type        = string
}

variable "create_templates" {
  description = "Weather to create template files based on project type"
  type        = bool
}

variable "workspace_metadata" {
  description = "Pretty straightforward"
  type        = any
}

variable "extra_vars" {
  description = "Extra variables dictionary"
  type        = map(string)
}

locals {
  # This dirs are based on: https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html#directory-layout
  project_dirs = [
    "production",
    "staging",
    "group_vars",
    "host_vars",
    "roles/common/tasks",
    "roles/common/handlers",
    "roles/common/templates",
    "roles/common/files",
    "roles/common/vars",
    "roles/common/defaults",
  ]

  templates = var.create_templates ? {
    site = {
      path    = "${var.workspace_path}/site.yml"
      content = templatefile("${path.module}/templates/site.yml.tpl", var.workspace_metadata)
    }
    production_inventory = {
      path    = "${var.workspace_path}/production/inventory.ini"
      content = templatefile("${path.module}/templates/inventory.ini.tpl", var.workspace_metadata)
    }
  } : {}

}

output "templates" {
  value = local.templates
}

output "project_dirs" {
  value = local.project_dirs
}
