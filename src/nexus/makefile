.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@./install.sh

.PHONY: reset
reset:
	@podman rm --force init-nexus-groovy || true
	@podman rm --force nexus || true
	@podman rmi --force localhost/leadof/nexus:latest || true
	@podman volume rm --force nexus-data || true
