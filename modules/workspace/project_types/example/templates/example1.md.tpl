# ${project_name}

## This is an example .md

${description != "" ? description : "Generated workspace for ${project_type} project"}

## For full documentation on templates check https://developer.hashicorp.com/terraform/language/functions/templatefile

%{ if created_by == "Ox" }
Hi Ox
%{ endif }
