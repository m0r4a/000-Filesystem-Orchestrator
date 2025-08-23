resource "null_resource" "create_directories" {
  count = length(local.directory_paths)

  triggers = {
    # you need a trigger
    # you wouln't be able to delete it otherwise
    base_path = var.base_path
  }

  provisioner "local-exec" {
    command = "mkdir -p '${local.directory_paths[count.index]}'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf '${self.triggers.base_path}'"
  }
}

resource "local_file" "templates" {
  for_each = local.template_files

  filename = each.value.path
  content  = each.value.content

  depends_on = [null_resource.create_directories]
}

resource "local_file" "metadata" {
  filename = "${local.workspace_path}/.metadata.json"

  content = jsonencode({
    metadata      = local.workspace_metadata
    directories   = local.directory_paths
    files_created = keys(local.template_files)
  })

  depends_on = [local_file.templates]
}

# default permissions are 731 for some reason
resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = <<-EOT
      find '${var.base_path}' -type d -exec chmod 755 {} \;
      find '${var.base_path}' -type f -exec chmod 644 {} \;
      if [ -d '${local.workspace_path}/scripts' ]; then
        find '${local.workspace_path}/scripts' -name "*.sh" -exec chmod +x {} \;
      fi
    EOT
  }

  depends_on = [local_file.metadata]
}
