locals {
  # Gathering information
  metadata_exists   = fileexists("${local.suffix_workspace_path}/.versions.json")
  existing_versions = local.metadata_exists ? try(jsondecode(file("${local.suffix_workspace_path}/.versions.json")).versions, {}) : {}

  current_hash = data.external.workspace_hash.result.hash
  next_version = format("version_%05d", length(local.existing_versions) + 1)
  hash_exists  = contains(values(local.existing_versions), local.current_hash)

  should_add_version = var.version_control && !local.hash_exists

  new_versions = local.should_add_version ? merge(local.existing_versions, {
    (local.next_version) = local.current_hash
  }) : local.existing_versions
}

data "external" "workspace_hash" {
  program = ["${path.module}/scripts/checksum", "${local.suffix_workspace_path}"]

  depends_on = [data.external.workspace_files]
}

resource "local_file" "project_metadata_versioned" {
  count    = var.version_control ? 1 : 0
  filename = "${local.suffix_workspace_path}/.versions.json"

  content = jsonencode({
    versions = local.new_versions
  })

  depends_on = [data.external.workspace_hash]
}
