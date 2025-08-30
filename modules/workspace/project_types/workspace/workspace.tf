# locals {
#   # Using this is a big brain move. You create directories at the workspace level instead
#   # of projects, but it can get a little messy, so I wouldn't recommend it
#   workspace_dirs = [
#   ]

#   workspace_templates = var.create_templates ? {
#     readme = {
#       path    = "${var.workspace_path}/README.md"
#       content = templatefile("${path.module}/templates/README.md.tpl", var.project_metadata)
#     }
#     gitignore = {
#       path    = "${var.workspace_path}/.gitignore"
#       content = file("${path.module}/templates/gitignore.tpl")
#     }
#   } : {}
# }


locals {
  workspace_dirs = flatten([
    for dir in ["workspace_module"] : "${var.workspace_path}/${dir}"
  ])

  workspace_templates = var.workspace_config.create_templates  ? {
    readme = {
      path    = "${var.workspace_path}/README.md"
      content = templatefile("${path.module}/templates/README.md.tpl", var.workspace_config.template_vars)
    }
    gitignore = {
      path    = "${var.workspace_path}/.gitignore"
      content = file("${path.module}/templates/gitignore.tpl")
    }
    } : {}
  }
