__PHONY__: build build-testing

build:
	docker build -t bbudd/stellar -f Dockerfile .

build-testing:
	docker build -t bbudd/stellar:testing -f Dockerfile.testing .