.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@podman build \
		--tag leadof/libraries:latest \
		--file ./containerfile \
		.
