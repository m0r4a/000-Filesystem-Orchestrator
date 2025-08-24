---
- name: ${meta_project_name} Deployment Playbook
  become: true
  vars:
    project_name: "${meta_project_name}"
    environment: "${meta_environment}"
    project_type: "${meta_project_type}"
    deployed_by: "${meta_created_by}"

  tasks:
    - name: Display deployment information
      debug:
        msg: |
          Deploying {{ meta_project_name }}
          Project Type: {{ meta_project_type }}
