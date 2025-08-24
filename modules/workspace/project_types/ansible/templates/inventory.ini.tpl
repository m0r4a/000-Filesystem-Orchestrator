# Ansible Inventory for ${meta_project_name}

[${meta_environment}]
# Add your production servers here
# Example:
# prod-web-01 ansible_host=10.0.1.10
# prod-web-02 ansible_host=10.0.1.11
# prod-db-01  ansible_host=10.0.2.10

[${meta_environment}:vars]
project_name=${meta_project_name}
environment=${meta_environment}
project_type=${meta_project_type}
%{ if meta_created_by != "" ~}
deployed_by=${meta_created_by}
%{ endif ~}

# Group definitions
[webservers]
# Web servers go here

[databases]  

[loadbalancers]
