locals {
  # Using this is a big brain move. You create directories at the workspace level instead
  # of projects, but it can get a little messy, so I wouldn't recommend it
  project_dirs = [
    "docs",
    "scripts"
  ]

  workspace_templates = var.create_templates ? {
    readme = {
      path    = "${var.workspace_path}/README.md"
      content = templatefile("${path.module}/templates/README.md.tpl", var.project_metadata)
    }
    gitignore = {
      path    = "${var.workspace_path}/.gitignore"
      content = file("${path.module}/templates/gitignore.tpl")
    }
    checksums = {
      path    = "${var.workspace_path}/scripts/checksum"
      content = file("${path.module}/templates/checksum")
    }

  } : {}

}
