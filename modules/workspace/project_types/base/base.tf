locals {
  project_dirs = [
  ]

  base_templates = var.create_templates ? {
    # base_file = {
    #   path    = "${var.project_path}/<something>"
    #   content = templatefile("${path.module}/templates/<something>.tpl", var.template_vars)
    # }
  } : {}

}
