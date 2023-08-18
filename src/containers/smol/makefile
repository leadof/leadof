.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@pnpm container:build

.PHONY: clean
clean:
	@rm --recursive --force \
		./.wireit/*/cache \
		./.task-output/

.PHONY: reset
reset: clean
	@rm --recursive --force \
		./.containers/ \
		./.wireit/ \
		./node_modules/
	@podman rmi --force localhost/leadof/smol || true
	@podman rmi --force ghcr.io/leadof/leadof/smol || true
