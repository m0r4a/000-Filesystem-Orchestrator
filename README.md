# 000-Filesystem-Orchestrator

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D%201.6.0-blue)](https://www.terraform.io/)

## Overview
This Terraform module allows you to create and manage structured workspaces with different project types (Terraform, Ansible, custom examples, etc.), including automatic templates and a basic version control system.


## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Key Concepts](#key-concepts)
- [Project Types](#project-types)
- [Examples](#examples)
- [Advanced Usage](#advanced-usage)
- [Project Structure](#project-structure)
- [Documentation](#documentation)

## Features

- **Flexibility**: It's "designed" in a way that allows easy addition of new `project_types` and templates
- **Workspace Management**: Creates organized structures for different project types
- **Smart Templates**: Automatically generates base files according to project type
- **Metadata System**: Tracks project information and changes
- **Multiple Project Types**: Native support for Terraform, Ansible, and custom projects
- **Basic Version Control**: Change tracking with corresponding hash on each apply

## Requirements

- **Terraform**: `>= 1.6.0`
- **Providers**:
  - `hashicorp/local`: `~> 2.5`
  - `hashicorp/null`: `~> 3.2`

## Quick Start

### Basic Project Creation

```hcl
module "my_project" {
  source = "./modules/workspace"
  
  project_name    = "web-application"
  workspace_path  = "./workspace"
  project_type    = "terraform"
  created_by      = "DevOps Team"
  description     = "Main web application infrastructure"
  environment     = "production"
  
  create_templates = true
  
  tags = {
    Team        = "Platform"
    Environment = "prod"
    Component   = "web"
  }
}
```

### Using the examples

#### Makefile

```bash
# View available commands
make help

# Try different project types
make examples-terraform          # Basic Terraform project
make examples-ansible            # Ansible playbook structure
make examples-example            # Full-featured example
make examples-terraform-ansible  # Combined setup

# Clean up
make examples-destroy
make examples-clean
```

#### Terraform

```bash
cd tf_examples/example
terraform init
terraform apply
```

## Key Concepts

### Architecture Components

- **Workspace**: Root container holding multiple projects and shared resources
- **Project**: Individual component with its own structure, metadata, and files
- **Project Type**: Template definition specifying files, directories, and structure to create
- **Workspace Master**: Designated project managing workspace-level configuration and templates

### Special Project Types

- **base**: Minimal project structure without predefined templates
- **workspace**: Controls workspace-level templates and configuration (requires `workspace_master = true`)
- **common**: Templates or directories applied to all projects in the workspace (requires `common = true`)

### File System Components

```
workspace/
├── .seed.json              # Initial workspace state hash
├── .versions.json          # Version history (if version_control = true)
├── project-a/
│   ├── .metadata.json      # Project metadata and configuration
│   └── [project files]     # Generated templates and custom files
└── project-b/
    ├── .metadata.json
    └── [project files]
```

### Metadata Files

- **`.seed.json`**: Cryptographic hash of workspace initial state for change detection
- **`.metadata.json`**: Static file containing project name, type, creation date, creator, description, environment, and tags
- **`.versions.json`**: Version tracking file maintaining history of workspace changes

## Project Types

| Type | Purpose | Generated Files | Use Cases |
|------|---------|----------------|-----------|
| **base** | Minimal structure | None | Custom projects, starting templates |
| **terraform** | Infrastructure as Code | `main.tf`, `variables.tf`, `outputs.tf` | Terraform modules, infrastructure |
| **ansible** | Configuration Management | `inventory.ini`, `site.yml`, role structure | Server configuration, deployments |
| **example** | Feature demonstration | Custom templates with variables | Learning, reference implementation |
| **workspace** | Workspace management | Workspace-level templates | Shared configuration, documentation |
| **common** | Shared components | Cross-project templates | Shared utilities, common files |

## Examples

### Available Examples

| Example | Description | Features Demonstrated |
|---------|-------------|----------------------|
| `example/` | Complete feature showcase | All capabilities, custom templates, variables |
| `terraform/` | Infrastructure project | Terraform templates, basic setup |
| `ansible/` | Configuration management | Ansible structure, inventory management |
| `terraform-ansible/` | Hybrid approach | Combined infrastructure and configuration |


Output workspace: `./workspace_example`

## Advanced Usage

### Multi-Project Workspace

```hcl
# (workspace master)
module "frontend" {
  source = "./modules/workspace"
  
  project_name     = "frontend"
  workspace_path   = "./my-application"
  project_type     = "base"
  workspace_master = true
  version_control  = true
  common          = true
  
  description = "React frontend application"
  environment = "production"
}

module "backend" {
  source = "./modules/workspace"
  
  project_name   = "api"
  workspace_path = "./my-application"
  project_type   = "terraform"
  common        = true
  
  description = "Backend API infrastructure"
  
  template_vars = {
    api_port     = "3000"
    database_url = "postgres://localhost:5432/api"
  }
}

# Configuration management
module "config" {
  source = "./modules/workspace"
  
  project_name   = "configuration"
  workspace_path = "./my-application"
  project_type   = "ansible"
  common        = true
  
  extra_dirs = ["collections"]
}
```

### Custom Templates with Variables

```hcl
module "api_service" {
  source = "./modules/workspace"
  
  project_name    = "user-service"
  project_type    = "base"
  create_templates = true
  
  template_vars = {
    service_name    = "user-management-api"
    service_port    = "8080"
    database_name   = "users"
    redis_enabled   = "true"
  }
  
  extra_dirs = [
    "config",
    "scripts/deployment",
    "docs/api"
  ]
  
  tags = {
    Service = "user-management"
    Tier    = "backend"
  }
}
```

### Configuration Rules

- **Workspace Master**: Only one project per workspace should have `workspace_master = true`
- **Version Control**: Requires a workspace master to be enabled
- **Common Templates**: Only projects with `common = true` receive shared templates
- **Template Variables**: Available to projects with `create_templates = true`

> Declare a variable and not using it does not cause any error, but if you try to use it without passing it, it will throw an error

## Project Structure

```
000-Filesystem-Orchestrator/
├── main.tf                          # Another sort of example file
├── Makefile                         # Development commands
├── modules/workspace/               # Main module
│   ├── main.tf                      # Module entry point
│   ├── variables.tf                 # Input definitions
│   ├── outputs.tf                   # Output definitions
│   ├── locals.tf                    # Local values
│   ├── providers.tf                 # Provider configurations
│   ├── version_control.tf           # Change tracking logic
│   ├── project_types.tf             # Project type orchestration
│   └── project_types/               # Project type implementations
│       ├── base/
│       ├── terraform/
│       ├── ansible/
│       ├── example/
│       ├── workspace/               # Workspace-level templates
│       └── common/                  # Cross-project templates
├── tf_examples/                     # Usage examples
│   ├── example/
│   ├── terraform/
│   ├── ansible/
│   └── terraform-ansible/
├── docs/
│   └── modules_workspace.md        # Module reference
└── README.md                       # This file
```

## Documentation

- **[How the .tf interact](./docs/modules_workspace.md#module-flow)**: A flow diagram of how the .tf files interact at a conceptual level
- **[Module content](./docs/modules_workspace.md#module-content)**: Complete submodules (project_types), variables and outputs documentation
- **[Custom Project Types Guide](./docs/modules_workspace.md#how-to-create-your-own-project-type)**: Creating your own project types
- **[Examples](./tf_examples/)**: Working examples for different use cases

### Development Workflow

```bash
# Run examples
make examples-example

# Destroy the resources
make examples-destroy

# Clean up
make examples-clean

# Add your own project type
cp -r modules/workspace/project_types/example modules/workspace/project_types/my_type
```

## Extra

- Maybe add a special variable for the workspace master to reduce the verbosity of the outputs?
