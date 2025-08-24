project_info:
  name: ${project_metadata.project_name}
  created_by: ${project_metadata.created_by}
  environment: ${project_metadata.environment}
  type: ${project_metadata.project_type}

# Extra variables
custom_config:
%{ for key, value in extra_vars ~}
  ${key}: ${value}
%{ endfor ~}

# Mixed usage example
deployment:
  project: ${project_metadata.project_name}
  target: ${project_metadata.environment}
%{ if lookup(extra_vars, "deploy_version", "") != "" ~}
  version: ${extra_vars.deploy_version}
%{ endif ~}
