locals {
  project_dirs = [
    "modules",
  ]

  templates = var.create_templates ? {
    terraform_main = {
      path    = "${var.project_path}/main.tf"
      content = templatefile("${path.module}/templates/main.tf.tpl", var.project_metadata)
    }
    terraform_variables = {
      path    = "${var.project_path}/variables.tf"
      content = templatefile("${path.module}/templates/variables.tf.tpl", var.project_metadata)
    }
    terraform_outputs = {
      path    = "${var.project_path}/outputs.tf"
      content = templatefile("${path.module}/templates/outputs.tf.tpl", var.project_metadata)
    }
  } : {}
}
