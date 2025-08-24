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
