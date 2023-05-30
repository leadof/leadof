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

.PHONY: check
check: check-formatting

.PHONY: decision
decision:
ifndef n
	$(error Missing required argument "n" for the decision number.)
endif
ifndef name
	$(error Missing required argument "name" for the decision.)
endif
	@cp "./src/docs/decisions/adr-template.md" "./src/docs/decisions/$(n)-$(name).md"
