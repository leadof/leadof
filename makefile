.DEFAULT_GOAL:=all

all: init

.PHONY: init
init:
	@./executable
	@./init.sh

.PHONY: init-dev
init-dev:
	@./executable
	@./init-dev

.PHONY: decision
decision:
ifndef n
	$(error Missing required argument "n" for the decision number.)
endif
ifndef name
	$(error Missing required argument "name" for the decision.)
endif
	@cp "./src/docs/decisions/adr-template.md" "./src/docs/decisions/$(n)-$(name).md"
