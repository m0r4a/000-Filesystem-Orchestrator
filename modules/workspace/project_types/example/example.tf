locals {
  project_dirs = [
    "example1",
    "example2"
  ]

  templates = var.create_templates ? {
    # In this example you are passing the variables directly
    # you reference it as ${var1}
    example1 = {
      path = "${var.project_path}/example1.txt"
      content = templatefile("${path.module}/templates/example1.txt.tpl", var.template_vars)
    }

    # In this example you are also passing your template_vars
    # but you're merging them with the metadata vars, you
    # reference them like in example1
    example2 = {
      path = "${var.project_path}/example2.md"
      content = templatefile("${path.module}/templates/example2.md.tpl", merge(
        var.project_metadata,
        var.template_vars
      ))
    }

    # In this example you are passing the values as separate objects
    # you reference it as ${workspace_metadata.var1}
    # I recommend using the first one unless you want to use a variable
    # name that exists on the workspace_metadata
    example3 = {
      path = "${var.project_path}/example3.yaml"
      content = templatefile("${path.module}/templates/example3.yaml.tpl", {
        project_metadata = var.project_metadata
        extra_vars       = var.template_vars
      })
    }

  } : {}

}
