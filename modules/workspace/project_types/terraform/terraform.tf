locals {
  project_dirs = [
    "modules",
  ]

  templates = var.project.create_templates ? {
    terraform_main = {
      path    = "${var.project.project_path}/main.tf"
      content = templatefile("${path.module}/templates/main.tf.tpl", var.project.template_vars)
    }
    terraform_variables = {
      path    = "${var.project.project_path}/variables.tf"
      content = templatefile("${path.module}/templates/variables.tf.tpl", var.project.template_vars)
    }
    terraform_outputs = {
      path    = "${var.project.project_path}/outputs.tf"
      content = templatefile("${path.module}/templates/outputs.tf.tpl", var.project.template_vars)
    }
  } : {}
}
