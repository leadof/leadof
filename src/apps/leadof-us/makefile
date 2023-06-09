.DEFAULT_GOAL:=all

all: prerequisites check-lint check-test install check-e2e

.PHONY: prerequisites
prerequisites:
	@pnpm install --frozen-lockfile
	@pnpm dlx playwright install
	@pnpm dlx playwright install-deps

.PHONY: pre
pre: prerequisites

.PHONY: check-lint
check-lint:
	@./lint.sh

.PHONY: check-test
check-test:
	@pnpm test

.PHONY: check-e2e
check-e2e: prerequisites
	@pnpm e2e

.PHONY: check-performance
check-performance:
	@node ./check-performance.js

.PHONY: check
check: check-lint check-test check-e2e

.PHONY: install
install:
	@./install.sh

.PHONY: start
start:
	@./start.sh
# @pnpm ng run app:serve-ssr:production --port 4200

.PHONY: stop
stop:
	@./stop.sh

.PHONY: restart
restart: stop start

.PHONY: dev
dev: start
.PHONY: serve
serve: start
.PHONY: run
run: start

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

.PHONY: clean
clean:
	@podman rm --force leadof-us-start-container || true
	@rm -rf \
		./.angular/ \
		./coverage/ \
		./dist/ \
		./node_modules/ \
		./playwright-report/ \
		./www/ \
		./lighthouse-report.html \
		./performance-report*

.PHONY: install-container
install-container:
	@podman build \
		--tag leadof/us:latest \
		--file ./Containerfile \
		--ignorefile ./.containerignore \
		.

.PHONY: check-container
check-container:
	@podman build \
		--tag leadof/us:latest \
		--file ./Containerfile \
		--ignorefile ./.containerignore \
		--target lint \
		.

.PHONY: start-container
start-container: install-container
	@podman rm --force leadof-us-$@ || true
	@podman run --name leadof-us-$@ --detach --publish 4000:4000 leadof/us:latest
	@podman logs --follow leadof-us-$@
