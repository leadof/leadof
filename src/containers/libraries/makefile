.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@./install.sh

.PHONY: deploy
deploy:
	@./deploy.sh

.PHONY: clean
clean:
	@rm --recursive --force \
		./.wireit/*/cache \
		./dist/

.PHONY: reset
reset: clean
	@rm --recursive --force \
		./.wireit/ \
		./node_modules/
	@podman rmi --force localhost/leadof/libraries:latest || true
	@podman rmi --force ghcr.io/leadof/leadof/libraries:latest || true
