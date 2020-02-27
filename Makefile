IMAGE_TAG := nicolkill/enconta_test
REVISION=$(shell git rev-parse --short HEAD)
RUN_STANDARD := docker run --rm -v `pwd`:/app -w /app elixir:1.10
RUN := docker run --rm -v `pwd`:/app -w /app nicolkill/enconta_test:latest

all: build image

up:
	docker-compose up

build:
	$(RUN_STANDARD) mix do local.rebar --force, local.hex --force, deps.get, deps.compile, compile

image:
	docker build -t ${IMAGE_TAG}:${REVISION} .
	docker tag ${IMAGE_TAG}:${REVISION} ${IMAGE_TAG}:latest

testing:
	$(RUN) mix test
