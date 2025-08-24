resource "null_resource" "create_directories" {
  count = length(local.directory_paths)

  triggers = {
    # you need a trigger
    # you wouln't be able to delete it otherwise
    workspace_path = var.workspace_path
  }

  provisioner "local-exec" {
    command = "mkdir -p '${local.directory_paths[count.index]}'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf '${self.triggers.workspace_path}'"
  }
}

resource "local_file" "templates" {
  for_each = local.template_files

  filename = each.value.path
  content  = each.value.content

  depends_on = [null_resource.create_directories]
}

resource "local_file" "metadata" {
  filename = "${local.project_path}/.metadata.json"

  content = jsonencode({
    metadata      = local.project_metadata
    directories   = local.directory_paths
    files_created = keys(local.template_files)
  })

  depends_on = [local_file.templates]
}

# default permissions are 731 for some reason
resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = <<-EOT
      find '${var.workspace_path}' -type d -exec chmod 755 {} \;
      find '${var.workspace_path}' -type f -exec chmod 644 {} \;
      if [ -d '${local.project_path}/scripts' ]; then
        find '${local.project_path}/scripts' -name "*.sh" -exec chmod +x {} \;
      fi
    EOT
  }

  depends_on = [local_file.metadata]
}
