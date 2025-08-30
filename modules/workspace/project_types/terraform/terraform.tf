locals {
  project_dirs = flatten([
    for project_name, config in var.projects : [
      for dir in ["modules"] : "${config.project_path}/${dir}"
    ]
  ])

  templates = {
    for project_name, config in var.projects :
    project_name => config.create_templates ? {

    terraform_main = {
      path    = "${config.project_path}/main.tf"
      content = templatefile("${path.module}/templates/main.tf.tpl", config.template_vars)
    }
    terraform_variables = {
      path    = "${config.project_path}/variables.tf"
      content = templatefile("${path.module}/templates/variables.tf.tpl", config.template_vars)
    }
    terraform_outputs = {
      path    = "${config.project_path}/outputs.tf"
      content = templatefile("${path.module}/templates/outputs.tf.tpl", config.template_vars)
    }

    } : {}
  }
}
