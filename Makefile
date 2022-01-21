# Makefile based wrapper for automating building the AWS CDK Java applications
# This wrapper is meant for quick & easy install via:
#   $ curl -fsSL https://raw.githubusercontent.com/raccoons-co/cloud-quarks/main/aws-cdk/Makefile --output Makefile

.DEFAULT_GOAL := help

# Using 'sh -c' can avoid situation then VCS do not preserves file permissions
sh_c := sh -c

.PHONY: help
help: ## Print this help
	@echo "List of available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: aws-cdk
aws-cdk: ## Install AWS CDK
	$(sh_c) 'curl -fsSL https://raw.githubusercontent.com/raccoons-co/cloud-quarks/main/aws-cdk/install | sudo sh'

.PHONY: bootstrap-cdk
bootstrap-cdk: ## Bootstrapping AWS CDK environment
	$(sh_c) 'cdk bootstrap'

.PHONY: init-cdk-app
init-cdk-app: ## Initialize AWS CDK Java application
	@[ $(project) ] || ( echo "Usage: make init-cdk-app project=<NAME>" ; exit 1 )
	$(sh_c) 'git config --global user.email "init-cdk-app@cloud.quarks" && git config --global user.name "init-cdk-app"'
	$(sh_c) 'mkdir $(project) && cd $(project) && cdk init app --language=java'
	$(sh_c) 'cp Makefile $(project) && cd $(project) && git add Makefile && git branch -M main && git commit -m "Add Makefile"'

.PHONY: build
build: ## Build App Stack
	$(sh_c) 'mvn compile -q && cdk synth'

.PHONY: deploy
deploy: build ## Deploy App Stack
	$(sh_c) 'cdk deploy'

.PHONY: destroy
destroy:  ## Destroy App Stack
	$(sh_c) 'cdk destroy'
