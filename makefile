.DEFAULT_GOAL:=all

all: init check

.PHONY: init
init:
	@./init.sh

.PHONY: format
format:
	@pnpm format

.PHONY: check-formatting
check-formatting:
	@./check-formatting.sh

.PHONY: check-spelling
check-spelling:
	@./check-spelling.sh

.PHONY: check
check: check-formatting check-spelling

.PHONY: decision
decision:
ifndef n
	$(error Missing required argument "n" for the decision number.)
endif
ifndef name
	$(error Missing required argument "name" for the decision.)
endif
	@cp "./src/docs/decisions/adr-template.md" "./src/docs/decisions/$(n)-$(name).md"
