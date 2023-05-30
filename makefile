.DEFAULT_GOAL:=all

all: init check install

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

.PHONY:spellcheck
spellcheck: check-spelling

.PHONY: check
check: check-formatting check-spelling
	@pnpm --recursive lint
	@pnpm --recursive test

.PHONY: install
install:
	@pnpm --recursive build

.PHONY: decision
decision:
ifndef n
	$(error Missing required argument "n" for the decision number.)
endif
ifndef name
	$(error Missing required argument "name" for the decision.)
endif
	@cp "./src/docs/decisions/adr-template.md" "./src/docs/decisions/$(n)-$(name).md"

.PHONY: create-leadof-us
create-leadof-us:
	@echo 'N' | pnpm ionic start leadof-us blank \
		--type=angular-standalone \
		--no-deps \
		--no-git \
		--capacitor
	@mv ./leadof-us/ ./src/apps/leadof-us/
	@cd ./src/apps/leadof-us/ \
	&& rm -f ./package-lock.json \
	&& pnpm install \
	&& pnpm add -D @ionic/cli

.PHONY: pr
pr:
ifndef title
	$(error Missing required "title" argument)
endif
	@gh pr create --fill --assignee "@me" --label enhancement --title "feat: $(title)"

.PHONY: pr-chore
pr-chore:
ifndef title
	$(error Missing required "title" argument)
endif
	@gh pr create --fill --assignee "@me" --label chore --title "chore: $(title)"

.PHONY: pr-bug
pr-bug:
ifndef title
	$(error Missing required "title" argument)
endif
	@gh pr create --fill --assignee "@me" --label bug --title "bug: $(title)"

.PHONY: pr-docs
pr-docs:
ifndef title
	$(error Missing required "title" argument)
endif
	@gh pr create --fill --assignee "@me" --label documentation --title "docs: $(title)"
