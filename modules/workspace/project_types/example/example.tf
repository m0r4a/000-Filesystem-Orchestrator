locals {
  project_dirs = [
    "example1",
    "example2"
  ]

  templates = var.project.create_templates ? {
    # This should be the "standard" use case, you only pass the template_vars
    # and you reference them as ${your_var}
    example1 = {
      path    = "${var.project.project_path}/example1.txt"
      content = templatefile("${path.module}/templates/example1.txt.tpl", var.project.template_vars)
    }

    # In this example you are also passing your template_vars
    # but you're merging them with the metadata vars, you
    # reference them like in example1
    example2 = {
      path = "${var.project.project_path}/example2.md"
      content = templatefile("${path.module}/templates/example2.md.tpl", merge(
        var.project.template_vars, var.project.metadata)
      )
    }

    # In this example you are passing the values as separate objects
    # you reference it as ${workspace_metadata.var1}
    # I recommend using the first one unless you want to use a variable
    # name that exists on the workspace_metadata
    example3 = {
      path = "${var.project.project_path}/example3.yaml"
      content = templatefile("${path.module}/templates/example3.yaml.tpl", {
        project_metadata = var.project.metadata
        extra_vars       = var.project.template_vars
      })
    }
  } : {}
}
