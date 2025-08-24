locals {
  project_dirs = [
    "modules",
  ]

  templates = var.create_templates ? {
    terraform_main = {
      path    = "${var.workspace_path}/main.tf"
      content = templatefile("${path.module}/templates/main.tf.tpl", var.workspace_metadata)
    }
    terraform_variables = {
      path    = "${var.workspace_path}/variables.tf"
      content = templatefile("${path.module}/templates/variables.tf.tpl", var.workspace_metadata)
    }
    terraform_outputs = {
      path    = "${var.workspace_path}/outputs.tf"
      content = templatefile("${path.module}/templates/outputs.tf.tpl", var.workspace_metadata)
    }
  } : {}
}
