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

variable "extra_vars" {
  description = "Extra variables dictionary"
  type        = map(string)
}

locals {
  project_dirs = [
    "example1",
    "example2"
  ]

  templates = var.create_templates ? {
    # In this example you are passing the variables directly
    # you reference it as ${var1}
    example1 = {
      path = "${var.workspace_path}/example1.md"
      content = templatefile("${path.module}/templates/example1.md.tpl", merge(
        var.workspace_metadata,
        var.extra_vars
      ))
    }

    # In this example you are passing the values as separate objects
    # you reference it as ${workspace_metadata.var1}
    # I recommend using the first one unless you want to use a variable
    # name that exists on the workspace_metadata
    example2 = {
      path = "${var.workspace_path}/example2.yaml"
      content = templatefile("${path.module}/templates/example2.yaml.tpl", {
        workspace_metadata = var.workspace_metadata
        extra_vars         = var.extra_vars
      })
    }

  } : {}

}

output "templates" {
  value = local.templates
}

output "project_dirs" {
  value = local.project_dirs
}
