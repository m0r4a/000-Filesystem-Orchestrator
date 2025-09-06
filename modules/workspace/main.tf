resource "null_resource" "create_directories" {
  count = length(local.all_project_dirs)

  triggers = {
    workspace_path = local.suffix_workspace_path
  }

  provisioner "local-exec" {
    command = "mkdir -p '${local.all_project_dirs[count.index]}'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf '${self.triggers.workspace_path}'"
  }

  depends_on = [random_string.suffix]
}

resource "local_file" "templates" {
  for_each = local.all_templates

  filename = each.value.path
  content  = each.value.content

  depends_on = [null_resource.create_directories]
}

# default permissions are 731 for some reason
resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = <<-EOT
     find '${local.suffix_workspace_path}' -type d -exec chmod 755 {} \;
     find '${local.suffix_workspace_path}' -type f -exec chmod 644 {} \;
   EOT
  }

  depends_on = [local_file.templates]
}

resource "null_resource" "workspace_seed" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/checksum ${local.suffix_workspace_path} > ${local.suffix_workspace_path}/.seed.json"
  }

  lifecycle {
    replace_triggered_by = []
  }

  depends_on = [null_resource.set_permissions]
}

data "external" "workspace_files" {
  program    = ["${path.module}/scripts/workspace_files", "${local.suffix_workspace_path}"]
  depends_on = [null_resource.workspace_seed]
}
