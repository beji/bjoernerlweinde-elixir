SHELL := /bin/bash

ifeq ($(V),1)
  Q =
else
  Q = @
endif

CONTAINER=beji/bjoernerlweinde
HTTP_HOST=bjoernerlwein.de
HTTP_PORT=80

PHONY+=all
all: container

.secret:
	mix phx.gen.secret 32 > $@

PHONY+=container
container: .secret
	docker build \
		-t ${CONTAINER}:${VERSION} \
		-t ${CONTAINER}:latest \
		--build-arg SECRET_KEY_BASE=$$(cat .secret) \
		--build-arg HTTP_HOST=${HTTP_HOST} \
		--build-arg HTTP_PORT=${HTTP_PORT} \
		.

.PHONY: $(PHONY)