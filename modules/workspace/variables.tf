variable "project_name" {
  description = "Name of the project to create"
  type        = string

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 64
    error_message = "The name of the workspace must be between 1 and 64 charactesr."
  }
}

variable "workspace_path" {
  description = "Base path where the workspace will be created"
  type        = string
  default     = "./workspace"

  validation {
    condition     = length(var.workspace_path) > 0
    error_message = "Base path cannot be empty"
  }
}

variable "project_type" {
  description = "The type of project you want to create"
  type        = string
}

variable "environment" {
  description = "Type of environment (dev, prod, etc.)"
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Environment must contain only lowercase letters, numbers and hypens"
  }
}

variable "created_by" {
  description = "User or program creating the workspace"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the workspace purpose"
  type        = string
  default     = ""
}

variable "extra_dirs" {
  description = "Extra directories to create in the workspace"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for dir in var.extra_dirs : can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_/.]*[a-zA-Z0-9]$", dir))
    ])

    error_message = "Directory names must only contain alphanumerics, hyphens, underscores and forward slashes"
  }
}

variable "template_vars" {
  description = "Variables for the templates"
  type        = map(string)
  default     = {}

  validation {
    condition     = var.create_templates || length(var.template_vars) == 0
    error_message = "template_vars can only be set if create_templates = true"
  }
}

variable "common" {
  description = "Enables the common module"
  type        = bool
  default     = false
}

variable "workspace_master" {
  description = "This variable determines whether this project will be responsible for passing its variables to the templates at the workspace level"
  type        = bool
  default     = false
}

variable "version_control" {
  description = "This determines whether you want to use version control in your projects or not"
  type        = bool
  default     = false
}

variable "create_templates" {
  description = "Weather to create template files based on project type"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to associate with the project"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9-_]+$", k))
    ])

    error_message = "Tag keys must only contain alphanumerics, hyphens and underscores"
  }
}
