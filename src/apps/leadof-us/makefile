.DEFAULT_GOAL:=all

all: prerequisites check install

.PHONY: prerequisites
prerequisites:
	@pnpm install --frozen-lockfile

.PHONY: pre
pre: prerequisites

.PHONY: check-lint
check-lint:
	@pnpm lint

.PHONY: check-test
check-test:
	@pnpm test

.PHONY: check-performance
check-performance:
	@[ -d "./lighthouse/" ] || mkdir ./lighthouse/
	@pnpm lighthouse \
		http://localhost:4200 \
		--output html \
		--output-path ./lighthouse/app.performance-report.html \
		 --chrome-flags="--headless"

.PHONY: check
check: check-lint check-test

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
