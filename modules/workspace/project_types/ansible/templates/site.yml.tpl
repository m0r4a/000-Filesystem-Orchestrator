---
- name: ${workspace_name} Deployment Playbook
  become: true

  vars:
    project_name: "${workspace_name}"
    environment: "${environment}"
    project_type: "${project_type}"
    deployment_date: "${created_at}"
    deployed_by: "${created_by}"
    
  tasks:
    - name: Display deployment information
      debug:
        msg: |
          Deploying {{ project_name }}
          Project Type: {{ project_type }}
          Deployment Date: {{ deployment_date }}
