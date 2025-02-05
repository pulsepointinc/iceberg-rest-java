VERSION=$(shell git describe --tags --dirty --match "[0-9\.]*" || echo 0.0.1)

version:
	@echo $(VERSION)

IMAGE_REGISTRY=registry.pulsepoint.com
IMAGE_NAME=forge/iceberg-rest-java/ma2

.PHONY: build
build:
	docker build -t "$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(VERSION)" .

.PHONY: bash
bash:
	docker run -it "$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(VERSION)" bash

.PHONY: push
push:
	docker push "$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(VERSION)"
