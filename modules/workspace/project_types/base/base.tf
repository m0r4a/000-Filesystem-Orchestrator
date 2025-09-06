locals {
  project_dirs = [
    ""
  ]

  templates = var.project.create_templates ? {
    # "base_file" = {
    #   path    = "${config.project_path}/<something>"
    #   content = templatefile("${path.module}/templates/<something>.tpl", config.template_vars)
    # }

  } : {}
}
