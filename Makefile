.DEFAULT_GOAL := help

# Using 'sh -c' can avoid situation then VCS do not preserves file permissions
sh_c := sh -c


.PHONY: help
help: ## Print this help
	@echo "List of available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: aws-cdk
aws-cdk:  ## Install AWS CDK
	$(sh_c) 'curl -fsSL https://raw.githubusercontent.com/raccoons-co/cloud-quarks/main/aws-cdk/install | sudo sh'

.PHONY: bootstrap-cdk
bootstrap-cdk:  ## Bootstrap AWS CDK environment
	$(sh_c) 'cdk bootstrap'

.PHONY: build
build:  ## Build App Stack
	$(sh_c) 'mvn compile -q'

.PHONY: deploy
deploy:  ## Deploy App Stack
	$(sh_c) 'cdk synth && cdk deploy'
