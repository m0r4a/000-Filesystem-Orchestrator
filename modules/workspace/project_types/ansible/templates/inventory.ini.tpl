# Ansible Inventory for ${workspace_name}
# Generated on: ${created_at}

[${environment}]
# Add your production servers here
# Example:
# prod-web-01 ansible_host=10.0.1.10
# prod-web-02 ansible_host=10.0.1.11
# prod-db-01  ansible_host=10.0.2.10

[${environment}:vars]
project_name=${workspace_name}
environment=${environment}
project_type=${project_type}
%{ if created_by != "" ~}
deployed_by=${created_by}
%{ endif ~}

# Group definitions
[webservers]
# Web servers go here

[databases]  

[loadbalancers]
