.PHONY: help validate format test lint
.PHONY: examples-terraform examples-ansible examples-terraform-ansible examples-example examples-clean examples-destroy
.PHONY: workspace-info workspace-metadata tools-help security-scan

.DEFAULT_GOAL := help

TERRAFORM_VERSION ?= 1.12.1
EXAMPLES_DIR ?= ./tf_examples
WORKSPACE_DIR ?= $(shell find ./ -name ".metadata.json" | head -1 | xargs dirname | xargs dirname)
SCRIPTS_DIR ?= ./scripts

RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Helper function to run terraform example in examples_tf
define run_terraform_example
	@echo -e "$(BLUE)Running Terraform example: $(1)$(NC)"
	@if [ -f "$(EXAMPLES_DIR)/$(1)/$(1).tf" ]; then \
		cd "$(EXAMPLES_DIR)/$(1)" && \
		echo -e "$(BLUE)Initializing Terraform for $(1).tf...$(NC)" && \
		terraform init && \
		echo -e "$(BLUE)Creating Terraform plan for $(1).tf...$(NC)" && \
		terraform plan -var-file="$(1).tf" -out=$(1).tfplan 2>/dev/null || terraform plan -out=$(1).tfplan && \
		echo -e "$(BLUE)Applying Terraform configuration for $(1).tf...$(NC)" && \
		terraform apply $(1).tfplan && \
		echo -e "$(GREEN)Example $(1) deployed successfully$(NC)"; \
	else \
		echo -e "$(RED)Error: Example file $(EXAMPLES_DIR)/$(1).tf not found$(NC)"; \
		exit 1; \
	fi
endef


help:
	@echo -e "$(BLUE)Handy tools for the project$(NC)"
	@echo -e ""
	@echo -e "$(YELLOW)Usage:$(NC)"
	@echo -e "  make <target>"
	@echo -e ""
	@echo -e "$(YELLOW)Main Targets:$(NC)"
	@echo -e "  $(GREEN)help$(NC)                        Display this message"
	@echo -e "  $(GREEN)validate$(NC)                    Run terraform validate"
	@echo -e "  $(GREEN)format$(NC)                      Run terraform fmt"
	@echo -e "  $(GREEN)lint$(NC)                        Run tflint and shellcheck"
	@echo -e "  $(GREEN)test$(NC)                        Run validate & format & lint"
	@echo -e "  $(GREEN)security-scan$(NC)               Run tfsec"
	@echo -e "  $(GREEN)tools-help$(NC)                  Display the tools information"
	@echo -e ""
	@echo -e "$(YELLOW)Example Targets:$(NC)"
	@echo -e "  $(GREEN)examples-terraform$(NC)          Deploy terraform.tf example"
	@echo -e "  $(GREEN)examples-ansible$(NC)            Deploy ansible.tf example"
	@echo -e "  $(GREEN)examples-terraform-ansible$(NC)  Deploy terraform_ansible.tf example"
	@echo -e "  $(GREEN)examples-example$(NC)            Deploy example.tf example"
	@echo -e "  $(GREEN)examples-destroy$(NC)            Destroy your example workdir"
	@echo -e "  $(GREEN)examples-clean$(NC)              Clean your example tempfiles"
	@echo -e ""
	@echo -e "$(YELLOW)Workspace Management:$(NC)"
	@echo -e "  $(GREEN)workspace-metadata$(NC)          Show .metadata.json files from workspaces"
	@echo -e "  $(GREEN)workspace-info$(NC)              Display information about the workspace"

# Core Terraform operations
validate:
	@echo -e "$(BLUE)Validating Terraform configuration...$(NC)"
	terraform validate
	@echo -e "$(GREEN)Configuration valid$(NC)"

format-check:
	@echo -e "$(BLUE)Checking Terraform formatting...$(NC)"
	@if ! terraform fmt -check -recursive .; then \
		echo -e "$(RED)Files need formatting. Run 'make format'$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(GREEN)All files properly formatted$(NC)"

format:
	@echo -e "$(BLUE)Formatting Terraform files...$(NC)"
	terraform fmt -recursive .
	@echo -e "$(GREEN)Files formatted$(NC)"

lint:
	@echo -e "$(BLUE)Running Terraform lint checks...$(NC)"
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --recursive; \
		echo -e "$(GREEN)Terraform linting passed$(NC)"; \
	else \
		echo -e "$(YELLOW)tflint not found, skipping Terraform linting$(NC)"; \
	fi
	@if command -v shellcheck >/dev/null 2>&1 && [ -d "$(SCRIPTS_DIR)" ]; then \
		echo -e "$(BLUE)Running shell script checks...$(NC)"; \
		find $(SCRIPTS_DIR) -name "*.sh" -exec shellcheck {} + 2>/dev/null || true; \
		echo -e "$(GREEN)Shell script linting passed$(NC)"; \
	fi

test:
	@echo -e "$(BLUE)Running module tests...$(NC)"
	@$(MAKE) validate
	@$(MAKE) format-check
	@$(MAKE) lint
	@echo -e "$(GREEN)All tests passed$(NC)"

examples-terraform:
	$(call run_terraform_example,terraform)

examples-ansible:
	$(call run_terraform_example,ansible)

examples-terraform-ansible:
	$(call run_terraform_example,terraform_ansible)

examples-example:
	$(call run_terraform_example,example)

workspace-info:
	@echo -e "$(BLUE)Workspace Directory Information:\n$(NC)"
	@if [ -d "$(WORKSPACE_DIR)" ]; then \
		for workspace in $(WORKSPACE_DIR)/*/; do \
			if [ -d "$$workspace" ]; then \
				workspace_name=$$(basename "$$workspace"); \
				echo -e "$(GREEN)$$workspace_name:$(NC)"; \
				echo -e "  Path: $$workspace"; \
				echo -e "  Files: $$(find "$$workspace" -type f | wc -l)\n"; \
			fi; \
		done; \
	else \
		echo -e "$(YELLOW)No workspace directory found at $(WORKSPACE_DIR)$(NC)"; \
	fi

workspace-metadata:
	@echo -e "$(BLUE)Workspace Metadata Information:$(NC)"
	@echo -e ""
	@if [ -d "$(WORKSPACE_DIR)" ]; then \
		found_metadata=false; \
		for workspace in $(WORKSPACE_DIR)/*/; do \
			if [ -d "$$workspace" ] && [ -f "$${workspace}.metadata.json" ]; then \
				found_metadata=true; \
				workspace_name=$$(basename "$$workspace"); \
				echo -e "$(YELLOW)--- $${workspace_name^} project ---$(NC)"; \
				echo -e ""; \
				if command -v jq >/dev/null 2>&1; then \
					jq -r '.' "$${workspace}.metadata.json" 2>/dev/null || cat "$${workspace}.metadata.json"; \
				else \
					cat "$${workspace}.metadata.json"; \
				fi; \
				echo -e ""; \
			fi; \
		done; \
		if [ "$$found_metadata" = false ]; then \
			echo -e "$(YELLOW)No .metadata.json files found in workspace directories$(NC)"; \
		fi; \
	else \
		echo -e "$(YELLOW)No workspace directory found at $(WORKSPACE_DIR)$(NC)"; \
	fi

examples-clean:
	@echo -e "$(BLUE)Cleaning temporary files...$(NC)"
	find $(EXAMPLES_DIR) -name "*.tfstate*" -delete 2>/dev/null || true
	find $(EXAMPLES_DIR) -name "*.tfplan" -delete 2>/dev/null || true
	find $(EXAMPLES_DIR) -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	find $(EXAMPLES_DIR) -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@echo -e "$(GREEN)Cleanup completed$(NC)"

examples-destroy:
# This is kind of sytax hell, this solves the issue of
# having more than one .tfstate on the tf_examples
	@for tfstate in $$(find "$(EXAMPLES_DIR)" -name "terraform.tfstate"); do \
		dir=$$(dirname "$$tfstate"); \
		cd "$$dir"; \
		if [ -n "$$(terraform state list 2>/dev/null)" ]; then \
			echo "Destroying $$(basename "$$dir")..."; \
			terraform destroy -auto-approve; \
		fi; \
		cd - > /dev/null; \
	done

tools-help:
	@echo -e "$(BLUE)Development Tools Installation Guide:$(NC)"
	@echo -e ""
	@echo -e "  - Terraform >= $(TERRAFORM_VERSION): https://terraform.io/downloads"
	@echo -e "  - tflint: https://github.com/terraform-linters/tflint"
	@echo -e "  - shellcheck: https://github.com/koalaman/shellcheck"
	@echo -e "  - tfsec: https://aquasecurity.github.io/tfsec/"
	@echo -e "  - jq: https://stedolan.github.io/jq/"
	@echo -e ""
	@echo -e "$(YELLOW)--- All this tools are optional ---$(NC)"

security-scan:
	@echo -e "$(BLUE)Running security scan...$(NC)"
	@if command -v tfsec >/dev/null 2>&1; then \
		tfsec .; \
		echo -e "$(GREEN)Security scan completed$(NC)"; \
	else \
		echo -e "$(YELLOW)tfsec not found. Install: https://aquasecurity.github.io/tfsec/$(NC)"; \
	fi
