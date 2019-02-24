GIT_SHA := $(shell git rev-parse --short HEAD)

# set COMPOSE_PROJECT_NAME to prevent docker-compose conflicts when running parallel builds on the same agent
ifdef BUILD_NUMBER
	BUILD_VERSION := $(FEATURE_NAME)-$(GIT_SHA)
	COMPOSE_PROJECT_NAME=$(JOB_NAME)-$(STAGE_NAME)
else
	BUILD_VERSION?=local
endif

# this directive will make $(BUILD_VERSION) accessible as a normal env var
export
APP_NAME=serverless-stack
REGISTRY_HOST ?= github.com
IMAGE_NAME ?= $(REGISTRY_HOST)/helderklemp/${APP_NAME}
APP_URL ?= https://${APP_DNS}


##################
# PUBLIC TARGETS #
##################
install: 
	@docker-compose down -v
	docker-compose run --rm builder npm install
build: 
	@docker-compose down -v
	docker-compose run --rm builder npm build
test: 
	@docker-compose down -v
	docker-compose run --rm builder npm run pretest
	docker-compose run --rm builder npm run test
start: 
	@docker-compose down -v
	docker-compose run --service-ports --rm sls npm start

dockerBuild: 
	docker build -t $(IMAGE_NAME):$(BUILD_VERSION) .

shell: 
	docker run -it -p 3000:3000 -v ${PWD}:/usr/src/app:Z $(IMAGE_NAME):$(BUILD_VERSION) bash

dockerPush:
	docker push $(IMAGE_NAME):$(BUILD_VERSION)

dockerPushLatest:
	docker pull $(IMAGE_NAME):$(BUILD_VERSION)
	docker tag $(IMAGE_NAME):$(BUILD_VERSION) $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):latest

dockerLogin:
	docker login $(REGISTRY_HOST)  -u "$(REGISTRY_USERNAME)" -p "$(REGISTRY_PASSWORD)"

