.DEFAULT_GOAL:=all

all: init check install

.PHONY: init
init:
	@pnpm --recursive install \
	&& pnpm run --recursive playwright install

.PHONY: check-integrity
check-integrity:
	@pnpm --recursive check

.PHONY: check-lint
check-lint:
	@pnpm --recursive lint

.PHONY: check-unit
check-unit:
	@pnpm --recursive test:unit --run --coverage

.PHONY: check-test
check-test:
	@pnpm --recursive test

.PHONY: check
check: check-integrity check-lint check-unit check-test

.PHONY: install
install:
	@pnpm --recursive build

.PHONY: format
format:
	@pnpm --recursive format

.PHONY: pr
pr:
	@git-town new-pull-request
