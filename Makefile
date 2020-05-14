SHELL:=bash

APP_NAME=nifi-s3

default: help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: bootstrap
bootstrap: ## Bootstrap local environment for first use
	make git-hooks

.PHONY: git-hooks
git-hooks: ## Set up hooks in .git/hooks
	@{ \
		HOOK_DIR=.git/hooks; \
		for hook in $(shell ls .githooks); do \
			if [ ! -h $${HOOK_DIR}/$${hook} -a -x $${HOOK_DIR}/$${hook} ]; then \
				mv $${HOOK_DIR}/$${hook} $${HOOK_DIR}/$${hook}.local; \
				echo "moved existing $${hook} to $${hook}.local"; \
			fi; \
			ln -s -f ../../.githooks/$${hook} $${HOOK_DIR}/$${hook}; \
		done \
	}

.PHONY: build-nifi-image
build-nifi-image: ## Build the container
	gradle build
	docker build -t $(APP_NAME) .

.PHONY: run-nifi-container
run-nifi-container:
	docker run -e AWS_REGION=$(AWS_REGION) -e S3_BUCKET=$(S3_BUCKET) -e S3_KEY=$(S3_KEY) -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) -p 8080:8080 -p 7070:7070 nifi-test

.PHONY: build-and-run
build-and-run:
	make build-nifi-image
	make run-nifi-container