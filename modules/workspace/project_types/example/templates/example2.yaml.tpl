project_info:
  name: ${workspace_metadata.workspace_name}
  created_by: ${workspace_metadata.created_by}
  environment: ${workspace_metadata.environment}
  type: ${workspace_metadata.project_type}

# Extra variables
custom_config:
%{ for key, value in extra_vars ~}
  ${key}: ${value}
%{ endfor ~}

# Mixed usage example
deployment:
  project: ${workspace_metadata.workspace_name}
  target: ${workspace_metadata.environment}
%{ if lookup(extra_vars, "deploy_version", "") != "" ~}
  version: ${extra_vars.deploy_version}
%{ endif ~}
