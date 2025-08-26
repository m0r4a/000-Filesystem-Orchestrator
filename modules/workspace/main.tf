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

# default permissions are 731 for some reason
resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = <<-EOT
     find '${var.workspace_path}' -type d -exec chmod 755 {} \;
     find '${var.workspace_path}' -type f -exec chmod 644 {} \;
     if [ -d '${local.project_path}/scripts' ]; then
       find '${local.project_path}/scripts' -type f -exec chmod u+x {} \;
     fi
     if [ -d '${var.workspace_path}/scripts' ]; then
       find '${var.workspace_path}/scripts' -type f -exec chmod u+x {} \;
     fi
   EOT
  }

  depends_on = [local_file.templates]
}

resource "local_file" "project_metadata" {
  filename = "${local.project_path}/.metadata.json"

  content = jsonencode({
    metadata      = local.project_metadata
    directories   = local.directory_paths
    files_created = keys(local.template_files)
  })

  lifecycle {
    ignore_changes = [content]
  }

  depends_on = [null_resource.set_permissions]
}

resource "null_resource" "workspace_seed" {
  # Since this thing is ran multiple times, each time per project
  # I can't use triggers, to decide if something occurs or not
  provisioner "local-exec" {
    command = <<-EOT
      if [ ! -f "${var.workspace_path}/.seed.json" ]; then
        ${path.module}/scripts/checksum ${var.workspace_path} > ${var.workspace_path}/.seed.json
      fi
    EOT
  }

  depends_on = [null_resource.set_permissions]
}

data "external" "workspace_files" {
  count      = var.workspace_master ? 1 : 0
  program    = ["${path.module}/scripts/workspace_files", "${var.workspace_path}"]
  depends_on = [null_resource.workspace_seed]
}
