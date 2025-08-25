project_info:
  name: ${project_metadata.meta_project_name}
  created_by: ${project_metadata.meta_created_by}
  environment: ${project_metadata.meta_environment}
  type: ${project_metadata.meta_project_type}

# Extra variables
custom_config:
%{ for key, value in extra_vars ~}
  ${key}: ${value}
%{ endfor ~}

# Mixed usage example
deployment:
  project: ${project_metadata.meta_project_name}
  target: ${project_metadata.meta_environment}
