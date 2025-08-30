locals {
  project_dirs = flatten([
    for project_name, config in var.projects : [
      for dir in ["example1", "example2"] : "${config.project_path}/${dir}"
    ]
  ])

  templates = {
    for project_name, config in var.projects :
    project_name => config.create_templates ? {
      "var_example1" = {
        path    = "${config.project_path}/example1.txt"
        content = templatefile("${path.module}/templates/example1.txt.tpl", config.template_vars)
      }
      "example2" = {
        path    = "${config.project_path}/example2.md"
        content = templatefile("${path.module}/templates/example2.md.tpl", config.template_vars)
      }
    } : {}
  }
}

# locals {
#   templates = var.create_templates ? {
#     # In this example you are also passing your template_vars
#     # but you're merging them with the metadata vars, you
#     # reference them like in example1
#     example2 = {
#       path = "${var.project_path}/example2.md"
#       content = templatefile("${path.module}/templates/example2.md.tpl", merge(
#         var.project_metadata,
#         var.template_vars
#       ))
#     }

#     # In this example you are passing the values as separate objects
#     # you reference it as ${workspace_metadata.var1}
#     # I recommend using the first one unless you want to use a variable
#     # name that exists on the workspace_metadata
#     example3 = {
#       path = "${var.project_path}/example3.yaml"
#       content = templatefile("${path.module}/templates/example3.yaml.tpl", {
#         project_metadata = var.project_metadata
#         extra_vars       = var.template_vars
#       })
#     }
#   } : {}
# }
