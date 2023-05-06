.DEFAULT_GOAL:=all

all: init check install

.PHONY: init
init:
	@./init

.PHONY: init-dev
init-dev:
	@./init-dev

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

.PHONY: install-firebase-project
install-firebase-project:
	@pnpm firebase projects:create \
		--display-name "$(name)" \
		--folder "$(folder)" \
		"$(name)"

.PHONY: install-leadof-me-nonprod
install-leadof-me-nonprod:
	@"$(MAKE)" install-firebase-project name=leadof-me-nonprod folder=leadof-me

.PHONY: clean
clean:
	@rm --recursive --force firebase-debug.log

.PHONY: reset
reset: clean
	@find . -name 'node_modules' -type d -prune -print -exec rm --recursive --force '{}' \;
	@find . -name '.svelte-kit' -type d -prune -print -exec rm --recursive --force '{}' \;
	@find . -name 'coverage' -type d -prune -print -exec rm --recursive --force '{}' \;
