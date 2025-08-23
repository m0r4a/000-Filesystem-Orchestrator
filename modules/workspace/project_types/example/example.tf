variable "workspace_path" {
  description = "The workspace path"
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
    "example1",
    "example2"
  ]

  templates = var.create_templates ? {
    example1 = {
      path    = "${var.workspace_path}/example1.md"
      content = templatefile("${path.module}/templates/example1.md.tpl", var.workspace_metadata)
    }
    example2 = {
      path    = "${var.workspace_path}/example2.yaml"
      content = file("${path.module}/templates/example2.yaml.tpl")
    }
  } : {}

}

output "templates" {
  value = local.templates
}

output "project_dirs" {
  value = local.project_dirs
}
