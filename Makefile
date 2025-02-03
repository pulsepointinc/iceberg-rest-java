VERSION=$(shell git describe --tags --dirty --match "[0-9\.]*" || echo 0.0.1)

version:
	@echo $(VERSION)

build:
	docker build -t registry.pulsepoint.com/iceberg-rest-java:$(VERSION) .

push:
	docker push registry.pulsepoint.com/iceberg-rest-java:$(VERSION)
