# ${meta_project_name}

## This is an example .md

${meta_description != "" ? meta_description : "Generated workspace for ${meta_project_type} project"}

## For full documentation on templates check https://developer.hashicorp.com/terraform/language/functions/templatefile

%{ if meta_created_by == "Ox" }
Hi Ox
%{ endif }
