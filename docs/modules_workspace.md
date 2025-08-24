## Modules

| Name | Source | Description |
|------|--------|-------------|
| <a name="module_workspace"></a> [workspace](#module\_workspace) | ./project_types/workspace | This is the module controlled by the `workspace_master`, this are the templates at workspace level |
| <a name="module_common"></a> [common](#module\_common) | ./project_types/common | These are templates that apply to all projects (it uses each project’s own metadata) |
| <a name="module_example_project"></a> [example\_project](#module\_example\_project) | ./project_types/example | This module is designed to be used as a reference for creating your own `projects` |
| <a name="module_terraform_project"></a> [terraform\_project](#module\_terraform\_project) | ./project_types/terraform | Contains very basic files for a Terraform project |
| <a name="module_ansible_project"></a> [ansible\_project](#module\_ansible\_project) | ./project_types/ansible | Contains the directory structure recommended by its documentation |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common"></a> [common](#input\_common) | Enables the common module | `bool` | `false` | no |
| <a name="input_create_templates"></a> [create\_templates](#input\_create\_templates) | Weather to create template files based on project type | `bool` | `true` | no |
| <a name="input_created_by"></a> [created\_by](#input\_created\_by) | User or program creating the workspace | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the workspace purpose | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Type of environment (dev, prod, etc.) | `string` | `"dev"` | no |
| <a name="input_extra_dirs"></a> [extra\_dirs](#input\_extra\_dirs) | Extra directories to create in the workspace | `list(string)` | `[]` | no |
| <a name="input_extra_vars"></a> [extra\_vars](#input\_extra\_vars) | Extra variables for the templates | `map(string)` | `{}` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project to create | `string` | n/a | yes |
| <a name="input_project_type"></a> [project\_type](#input\_project\_type) | The type of project you want to create | `string` | `"base"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to associate with the workspace | `map(string)` | `{}` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Terraform version for projects | `string` | `">= 1.12"` | no |
| <a name="input_workspace_master"></a> [workspace\_master](#input\_workspace\_master) | This variable determines whether this project will be responsible for passing its variables to the templates at the workspace level | `bool` | `false` | no |
| <a name="input_workspace_path"></a> [workspace\_path](#input\_workspace\_path) | Base path where the workspace will be created | `string` | `"./workspaces"` | no |

> [!IMPORTANT]
> - Only one project should have `workspace_master = true` unexpected behavior may occur otherwise.
> - If no project has `workspace_master = true`, the `workspace` module will not be used.
> - Only projects with `common = true` will use the `common` module.
> - The `common` module uses metadata specific to each project.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_directories_created"></a> [directories\_created](#output\_directories\_created) | List of created directories in the workspace |
| <a name="output_metadata"></a> [metadata](#output\_metadata) | Project metadata |
| <a name="output_metadata_file_path"></a> [metadata\_file\_path](#output\_metadata\_file\_path) | Path to the workspace metadata |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name used |
| <a name="output_template_files_created"></a> [template\_files\_created](#output\_template\_files\_created) | Template files created |
| <a name="output_workspace_path"></a> [workspace\_path](#output\_workspace\_path) | Full path of the created workspace |
