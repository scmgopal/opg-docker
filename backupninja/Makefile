.PHONY: build
newtag ?= latest
registryUrl ?= registry.service.dsd.io
image = $(registryUrl)/opguk/backupninja

build:
ifeq ($(dockerVersion),)
	docker build -t "$(image):$(newtag)" -t "$(image):latest" .
else
	docker build -t "$(image):$(newtag)" .
	docker tag -f "$(image):$(newtag)" "$(image):latest"
endif

