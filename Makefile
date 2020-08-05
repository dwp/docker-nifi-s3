SHELL:=bash

ORG_NAME=dwpdigital
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

.PHONY: build
build: ## Build the container
	gradle build
	docker build -t $(ORG_NAME)/$(APP_NAME) .

.PHONY: run
run: ## Run docker container detached
	@{ \
		echo "INFO: remove $(APP_NAME) container if exists"; \
		docker rm $(APP_NAME); \
		docker run --name $(APP_NAME) -d -e AWS_REGION=$(AWS_REGION_JAVA) \
		-e S3_BUCKET=$(S3_BUCKET) -e S3_KEY=$(S3_KEY) -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) -e AWS_PROFILE=$(AWS_PROFILE) \
		-p 8080:8080 -p 7070:7070 $(ORG_NAME)/$(APP_NAME); \
	}

.PHONY: s3-config
s3-config: ## Generate flow file and place in S3
	@{ \
		gzip -k flow.xml; \
		aws --region $(AWS_REGION) s3 cp flow.xml.gz s3://$(S3_BUCKET)/$(S3_KEY); \
		rm flow.xml.gz; \
	}

.PHONY: get-flow-file-locally-and-upload-to-s3
get-flow-file-locally-and-upload-to-s3: ## Get flow file from local container and upload to S3
	@{ \
	    docker cp ${CONTAINER_ID}:/opt/nifi/nifi-current/conf/flow.xml.gz flow.xml.gz; \
		aws --region $(AWS_REGION) s3 cp flow.xml.gz s3://$(S3_BUCKET)/$(S3_KEY); \
		rm flow.xml.gz; \
	}

.PHONY: stop
stop: ## Stop the container
	docker stop $(APP_NAME)

.PHONY: build-and-run
build-and-run:
	make s3-config
	make build
	make run
