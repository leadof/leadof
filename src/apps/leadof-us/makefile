.DEFAULT_GOAL:=all

.PHONY: all
all:
	@pnpm install
	@pnpm container:all

.PHONY: ci
ci:
	@pnpm container:all

.PHONY: prerequisites
prerequisites:
	@pnpm install --frozen-lockfile
	@pnpm dlx playwright install
	@pnpm dlx playwright install-deps

.PHONY: pre
pre: prerequisites

.PHONY: check-formatting
check-formatting:
	@pnpm container:check:formatting

.PHONY: check-testing
check-testing:
	@pnpm container:check:testing

.PHONY: check-e2e
check-e2e:
	@pnpm container:check:e2e

.PHONY: check-performance
check-performance:
	@node ./check-performance.js

.PHONY: check
check: check-formatting check-testing check-e2e

.PHONY: install
install:
	@pnpm container:build

.PHONY: start
start:
	@./start.sh

.PHONY: stop
stop:
	@./stop.sh

.PHONY: restart
restart: stop start

.PHONY: serve
serve: start
.PHONY: run
run: start

.PHONY: dev
dev:
	@pnpm install
	@pnpm local:dev:ssr

.PHONY: update
update:
	@pnpm ng update \
		@angular/animations \
		@angular/common \
		@angular/core \
		@angular/forms \
		@angular/platform-browser \
		@angular/platform-browser-dynamic \
		@angular/router \
		@angular-devkit/build-angular \
		@angular-eslint/builder \
		@angular-eslint/eslint-plugin \
		@angular-eslint/eslint-plugin-template \
		@angular-eslint/schematics \
		@angular-eslint/template-parser \
		@angular/cli \
		@angular/compiler \
		@angular/compiler-cli \
		@angular/language-service

.PHONY: start-container
start-container: install-container
	@podman rm --force leadof-us-$@ || true
	@podman run --name leadof-us-$@ --detach --publish 4000:4000 leadof/us
	@podman logs --follow leadof-us-$@

.PHONY: clean
clean:
	@podman rm --force leadof-us-start-container || true
	@rm --recursive --force \
		 ./.wireit/*/cache \
		./.task-output/

.PHONY: reset
reset: clean
	@rm --recursive --force \
		./.angular/ \
		./.containers/ \
		./.wireit/ \
		./node_modules/
	@podman rmi --force localhost/leadof/leadof-us/web || true
	@podman rmi --force ghcr.io/leadof/leadof-us/web || true
