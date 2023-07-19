.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@./install.sh

.PHONY: deploy
deploy: install
	@./deploy.sh

.PHONY: clean
clean:
	@rm -rf \
		./.wireit/*/cache \
		./dist/

.PHONY: reset
reset: clean
	@rm -rf \
		./.wireit/ \
		./node_modules/
	@podman rmi --force localhost/leadof/smol:latest || true
	@podman rmi --force ghcr.io/leadof/leadof/smol:latest || true
