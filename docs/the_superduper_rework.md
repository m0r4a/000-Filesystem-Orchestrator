So, I won't have proper english here, this isn't meant to be actually read but isn't private either, this is me analyzing
the project after the code review.

## Ox's comments

### 1st comment

`generate a unique workspace directory by appending a short randomized suffix`

This is a big issue with the project because each module call is actually a folder inside the workspace and they fall into
the same workspace by having the same path which is a big big design flaw, I have to actually think and kinda
re-do the project. This is my current idea:

```hcl
module "example_1" {
  source = "../../modules/workspace"

  workspace_path = "../../workdir_example"
  project_name   = "example_workspace"
  project_type   = "example"

  created_by  = "A nice user"
  description = "This works as a guideline for how you can implement a new project type"
  environment = "dev"

  create_templates = true
  common           = true
  version_control  = true
  workspace_master = true

  extra_dirs = [
    "my_extra_dir",
  ]

  template_vars = {
    custom_var = "for your templates"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}

module "example_2" {
  source = "../../modules/workspace"

  workspace_path = "../../workdir_example"
  project_name   = "Terraform"
  project_type   = "terraform"

  created_by  = "A nice user"
  description = "This is another project"
  environment = "dev"

  create_templates = true
  common           = true
  version_control  = true

  template_vars = {
    custom_var = "for your templates"
  }

  tags = {
    Team    = "Swarm Lords",
    Project = "000-Filesystem-Orchestrator"
  }
}
```

This is how you currently decalare two folders inside the workspace with two module calls.

This is how I want to make it work so the folders don't depend on having the same path
because, you know, this is how the project should've been in the first place:

```hcl
module "unified_workspace" {
  source = "./modules/workspace"
  
  workspace_path   = "./workspaces/my-workspace"
  version_control  = true

  workpace = {
    create_templates = true
    common = true  # idk why would you want this

    template_vars = {
      custom_var = "workspace_var"
    }
    extra_dirs = ["workspace_extra_dir"]
  }
  
  project_defaults = {
    environment      = "dev"
    create_templates = true
    common           = false
    tags = {
      Team    = "Swarm Lords"
      Project = "000-Filesystem-Orchestrator"
    }
    template_vars = {
      global_var = "shared_value"
    }
  }
  
  projects = {
    "example_project" = {
      project_type  = "example"
      description   = "This works as a guideline"
      common        = true  # Override default
      extra_dirs    = ["my_extra_dir"]
      template_vars = {
        custom_var  = "for your templates"
      }
    }
    
    "terraform_project" = {
      project_type  = "terraform"
      description   = "This is another project"
      template_vars = {
        custom_var  = "different value"
      }
    }
  }
}
```

#### Changes

- Now the projects will be created inside the module
- Metadata will be different, it will have `.workspace_metadata.json` at workspace level and `.project_metadata.json` at project level metadata.
- Now you can set workspace-level defaults 
- The metadata part is weird, Ox mentions that the goal is to enumerate files, compute checksums and write a manifest. It also should avoid the machine state so using `hostname` and `whoami` commands might be forbbiden.

### Conclusion so far

This will allow to have a single module call to declare all the workspaces needed so now I could add all the randomized prefix thing

I will have to think more about the project defaults thing I think having actual defaults to vars and then project defaults might be a lot of overhead but it's a very handy feature. Maybe adding a fully featured example and then a minimal one could improve this? I mean, showing that EVERYTHING is not actually needed and you won't add everything

```hcl
module "unified_workspace" {
  source = "./modules/workspace"
  
  workspace_path   = "./workspaces/my-workspace"

  projects = {
    "example_project" = {
      project_type  = "example"
    }
    
    "terraform_project" = {
      project_type  = "terraform"
    }
  }
}
```

I mean, I think this is a fairly simple config

Im worried about the idempotency tho, if you apply twice, wouldn't everything change because the workspace path changes? maybe add a trigger or lifecycle to that so it only runs once?
