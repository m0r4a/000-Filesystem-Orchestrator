locals {
  project_dirs = flatten([
    for project_name, config in var.projects : [
      for dir in [""] : "${config.project_path}/${dir}"
    ]
  ])

  templates = merge([
    for project_name, config in var.projects : 
    config.create_templates ? {

      # "base_file" = {
      #   path    = "${config.project_path}/<something>"
      #   content = templatefile("${path.module}/templates/<something>.tpl", config.template_vars)
      # }

    } : {}
  ]...)
}
