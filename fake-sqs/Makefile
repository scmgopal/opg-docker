.PHONY: build
newtag ?= latest
registryUrl ?= registry.service.opg.digital
image = $(registryUrl)/opguk/fake-sqs

build:
ifeq ($(dockerVersion),)
	docker build -t "$(image):$(newtag)" -t "$(image):latest" .
else
	docker build -t "$(image):$(newtag)" .
	docker tag -f "$(image):$(newtag)" "$(image):latest"
endif
