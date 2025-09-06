variable "version_control" {
  description = "This determines whether you want to use version control in your projects or not"
  type        = bool
  default     = false
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

variable "workspace" {
  description = "Settings for the workspace"
  type = object({
    environment      = optional(string, "dev")
    create_templates = optional(bool, true)
    common           = optional(bool, false)
    template_vars    = optional(map(string), {})
    extra_dirs       = optional(map(string), {})
    created_by       = optional(string, "")
    tags             = optional(map(string), {})
  })
  default = null

  validation {
    condition     = var.workspace == null || can(regex("^[a-z0-9-]+$", var.workspace.environment))
    error_message = "Environment must contain only lowercase letters, numbers and hyphens"
  }

  validation {
    condition = var.workspace == null || alltrue([
      for k, v in var.workspace.tags : can(regex("^[a-zA-Z0-9-_]+$", k))
    ])
    error_message = "Tag keys must only contain alphanumerics, hyphens and underscores"
  }

  validation {
    condition = var.workspace == null || alltrue([
      for dir in values(var.workspace.extra_dirs) : can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_/.]*[a-zA-Z0-9]$", dir))
    ])
    error_message = "Directory names must only contain alphanumerics, hyphens, underscores and forward slashes"
  }

  validation {
    condition     = var.workspace == null || var.workspace.create_templates || length(var.workspace.template_vars) == 0
    error_message = "template_vars can only be set if create_templates = true"
  }
}

variable "project_defaults" {
  description = "Default configuration for all projects in workspace"
  type = object({
    description      = optional(string)
    create_templates = optional(bool)
    common           = optional(bool)
    extra_dirs       = optional(list(string), [])
    template_vars    = optional(map(string))
    tags             = optional(map(string))
  })
  default = {}

  validation {
    condition = alltrue([
      for dir in var.project_defaults.extra_dirs : can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_/.]*[a-zA-Z0-9]$", dir))
    ])
    error_message = "Directory names must only contain alphanumerics, hyphens, underscores and forward slashes"
  }

  validation {
    condition = alltrue([
      for k, v in coalesce(var.project_defaults.tags, {}) : can(regex("^[a-zA-Z0-9-_]+$", k))
    ])
    error_message = "Tag keys must only contain alphanumerics, hyphens and underscores"
  }
}

variable "projects" {
  description = "Map of projects to create in the workspace"
  type = map(object({
    project_type     = string
    description      = optional(string, "")
    create_templates = optional(bool, true)
    common           = optional(bool, false)
    extra_dirs       = optional(list(string), [])
    template_vars    = optional(map(string), {})
    tags             = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for name, project in var.projects : length(name) > 0 && length(name) <= 64
    ])
    error_message = "Project names must be between 1 and 64 characters"
  }

  validation {
    condition = alltrue([
      for p in values(var.projects) : contains(local.projects_list, p.project_type)
    ])
    error_message = "Each project_type should be in var.projects_list."
  }

  validation {
    condition     = length(values(var.projects)) == length(distinct([for p in values(var.projects) : p.project_type]))
    error_message = "Each project_type must be unique across all projects."
  }

  validation {
    condition = alltrue([
      for name, project in var.projects : alltrue([
        for dir in project.extra_dirs : can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_/.]*[a-zA-Z0-9]$", dir))
      ])
    ])
    error_message = "Directory names must only contain alphanumerics, hyphens, underscores and forward slashes"
  }

  validation {
    condition = alltrue([
      for name, project in var.projects : alltrue([
        for k, v in coalesce(project.tags, {}) : can(regex("^[a-zA-Z0-9-_]+$", k))
      ])
    ])
    error_message = "Tag keys must only contain alphanumerics, hyphens and underscores"
  }

  validation {
    condition = alltrue([
      for name, project in var.projects :
      coalesce(project.create_templates, true) || length(coalesce(project.template_vars, {})) == 0
    ])
    error_message = "template_vars can only be set if create_templates = true"
  }
}
