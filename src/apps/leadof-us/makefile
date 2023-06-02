.DEFAULT_GOAL:=all

all: prerequisites check install

.PHONY: prerequisites
prerequisites:
	@pnpm install --frozen-lockfile
	@pnpm dlx playwright install
	@pnpm dlx playwright install-deps

.PHONY: pre
pre: prerequisites

.PHONY: check-lint
check-lint:
	@pnpm lint

.PHONY: check-test
check-test:
	@pnpm test

.PHONY: check-e2e
check-e2e:
	@pnpm e2e

.PHONY: check-performance
check-performance:
	@node ./check-performance.js

.PHONY: check
check: check-lint check-test check-e2e

.PHONY: install
install:
	@pnpm build

.PHONY: start
start:
	@pnpm start

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
	@rm -rf \
		./.angular/ \
		./coverage/ \
		./node_modules/ \
		./www/ \
		./performance-report*
