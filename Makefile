__PHONY__: build build-testing

build:
	docker build -t bbudd/research -f Dockerfile .

build-testing:
	docker build -t bbudd/research:testing -f Dockerfile.testing .