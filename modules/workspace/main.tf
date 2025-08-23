resource "null_resource" "create_directories" {
  count = length(local.directory_paths)

  provisioner "local-exec" {
    command = "mkdir -p '${local.directory_paths[count.index]}'"
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
    terraform_module = {
      version = "0.0.1"
      source  = path.module
    }
  })

  depends_on = [local_file.templates]
}

# default permissions are 731 for some reason
resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = <<-EOT
      find '${local.workspace_path}' -type d -exec chmod 755 {} \;
      find '${local.workspace_path}' -type f -exec chmod 644 {} \;
      if [ -d '${local.workspace_path}/scripts' ]; then
        find '${local.workspace_path}/scripts' -name "*.sh" -exec chmod +x {} \;
      fi
    EOT
  }

  depends_on = [local_file.metadata]
}
