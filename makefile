.DEFAULT_GOAL:=all

.PHONY: all
all:
	@pnpm container:all

# Prerequisites
.PHONY: prerequisites
prerequisites:
	@chmod +x ./prerequisites.sh \
	&& ./prerequisites.sh

.PHONY: pre
pre: prerequisites

.PHONY: install-dependencies
install-dependencies:
	@pnpm container:dependencies

.PHONY: install-src
install-src:
	@pnpm container:src

.PHONY: install-containers
install-containers:
	@pnpm build:containers

.PHONY: format
format:
	@pnpm local:format

.PHONY: check-formatting
check-formatting:
	@pnpm container:check:formatting

.PHONY: check-spelling
check-spelling:
	@pnpm container:check:spelling

.PHONY: check-quick
check-quick:
	@pnpm container:check:repository

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

# ARCHIVE 2023-07-22: kept for posterity
# .PHONY: create-leadof-us
# create-leadof-us:
# 	@echo 'N' | pnpm dlx @ionic/cli@7.1.1 start leadof-us blank \
# 		--type=angular-standalone \
# 		--no-deps \
# 		--no-git \
# 		--capacitor
# 	@mv ./leadof-us/ ./src/apps/leadof-us/
# 	@cd ./src/apps/leadof-us/ \
# 	&& rm --force ./package-lock.json \
# 	&& pnpm install \
# 	&& pnpm add -D @ionic/cli

.PHONY: update
update:
	@pnpm update \
		--color \
		--interactive \
		--recursive

.PHONY: upgrade
upgrade: update

.PHONY: update-latest
update-latest:
	@pnpm update \
		--color \
		--interactive \
		--recursive \
		--latest

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
	@rm --recursive --force ./.task-output/

.PHONY: reset
reset: clean
	@rm --recursive --force ./.containers/ ./.wireit/ ./node_modules/
	@podman rmi --force localhost/leadof/chrome-src:latest || true
	@podman rmi --force localhost/leadof/src:latest || true
	@podman rmi --force localhost/leadof/dependencies:latest || true

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
