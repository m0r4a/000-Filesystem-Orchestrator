locals {
  project_dirs = [
  ]

  common_templates = var.project.create_templates ? {
    common_file = {
      path    = "${var.project.project_path}/.common.md"
      content = templatefile("${path.module}/templates/common.md.tpl", var.project.metadata)
    }
  } : {}

}
