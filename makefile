.DEFAULT_GOAL:=ci

.PHONY: all
all:
	@pnpm all

# Continuous integration
.PHONY: ci
ci:
	@pnpm container:check

# Prerequisites
.PHONY: prerequisites
prerequisites:
	@chmod +x ./prerequisites.sh \
	&& ./prerequisites.sh

.PHONY: pre
pre: prerequisites

.PHONY: install-dependencies
install-dependencies:
	@./install-dependencies.sh

.PHONY: install-src
install-src:
	@./install-src.sh

.PHONY: install-containers
install-containers:
	@pnpm build:containers

.PHONY: format
format:
	@pnpm local:format

.PHONY: check-lint
check-lint:
	@./check-lint.sh

.PHONY: check-spelling
check-spelling:
	@./check-spelling.sh

.PHONY: spelling
spelling: check-spelling

.PHONY: check-quick
check-quick: check-lint check-spelling

.PHONY: check
check: check-quick install-containers
	@cd ./src/apps/leadof-us/ && "$(MAKE)" $@

.PHONY: install
install:
	@pnpm --recursive build

.PHONY: nexus
nexus:
	@podman pull docker.io/sonatype/nexus3
	@podman run \
		--name nexus \
		--detach \
		--publish 8081:8081 \
		--volume nexus-data:/nexus-data \
		docker.io/sonatype/nexus3

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
	@echo 'N' | pnpm dlx @ionic/cli@7.1.1 start leadof-us blank \
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

.PHONY: pr-ci
pr-ci:
ifndef title
	$(error Missing required "title" argument)
endif
	@gh pr create --fill --assignee "@me" --label chore --title "ci: $(title)"

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

.PHONY: clean
clean:
	@rm -rf ./test-results/
	@podman rm --force tmp_copy__leadof-dependencies_results || true
	@podman rm --force tmp_copy__lint_results || true
	@podman rm --force tmp_copy__spelling_results || true

.PHONY: reset
reset: clean
	@rm -rf ./.wireit/ ./node_modules/
	@podman rmi --force localhost/leadof/lint:latest || true
	@podman rmi --force localhost/leadof/spelling:latest || true

.PHONY: clean-all
clean-all: clean
	@cd ./src/containers/ && "$(MAKE)" clean
	@cd ./src/apps/leadof-us/ && "$(MAKE)" clean

.PHONY: reset-all
reset-all: clean-all reset
	@cd ./src/containers/ && "$(MAKE)" reset
	@cd ./src/apps/leadof-us/ && "$(MAKE)" reset
	@podman system prune --force
	@podman volume prune --force
