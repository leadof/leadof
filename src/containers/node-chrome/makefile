.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@pnpm container:build

.PHONY: deploy
deploy:
	@pnpm container:deploy

.PHONY: clean
clean:
	@rm --recursive --force \
		./.wireit/*/cache \
		./.task-output/

.PHONY: reset
reset: clean
	@rm --recursive --force \
		./.wireit/ \
		./node_modules/
	@podman rmi --force localhost/leadof/node-chrome:latest || true
	@podman rmi --force ghcr.io/leadof/leadof/node-chrome:latest || true
