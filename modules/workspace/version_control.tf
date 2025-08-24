locals {
  # Gathering information
  metadata_exists   = fileexists("${var.workspace_path}/.versions.json")
  existing_versions = local.metadata_exists ? try(jsondecode(file("${var.workspace_path}/.versions.json")).versions, {}) : {}

  current_hash = var.workspace_master ? data.external.workspace_hash[0].result.hash : "a workspace master is needed for calculating the hashes"
  next_version = format("hash_%06d", length(local.existing_versions) + 1)
  hash_exists  = contains(values(local.existing_versions), local.current_hash)

  should_add_version = var.version_control && var.workspace_master && !local.hash_exists

  new_versions = local.should_add_version ? merge(local.existing_versions, {
    (local.next_version) = local.current_hash
  }) : local.existing_versions
}

data "external" "workspace_hash" {
  count      = var.workspace_master ? 1 : 0
  program    = ["${var.workspace_path}/scripts/checksum", "${var.workspace_path}"]

  depends_on = [null_resource.set_permissions]
}

resource "local_file" "project_metadata_versioned" {
  count    = var.version_control ? 1 : 0
  filename = "${var.workspace_path}/.versions.json"

  content = jsonencode({
    versions      = local.new_versions
  })

  depends_on = [data.external.workspace_hash]
}
