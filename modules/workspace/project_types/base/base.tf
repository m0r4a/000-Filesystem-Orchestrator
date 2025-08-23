variable "base_path" {
  description = "This is the root folder for the project"
  type        = string
}

variable "create_templates" {
  description = "Weather to create template files based on project type"
  type        = bool
  default     = true
}

variable "workspace_metadata" {
  description = "Pretty straightforward"
  type        = any
}

locals {
  project_dirs = [
  ]

  base_templates = var.create_templates ? {
    readme = {
      path    = "${var.base_path}/README.md"
      content = templatefile("${path.module}/templates/README.md.tpl", var.workspace_metadata)
    }
    gitignore = {
      path    = "${var.base_path}/.gitignore"
      content = file("${path.module}/templates/gitignore.tpl")
    }
  } : {}

}

output "templates" {
  value = local.base_templates
}

output "project_dirs" {
  value = local.project_dirs
}
