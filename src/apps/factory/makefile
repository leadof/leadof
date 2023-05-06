.DEFAULT_GOAL:=all

all: leadof-me leadof-tech leadof-us

# The `update` command does not install the latest of "vitest".
# SvelteKit does not install a test coverage library (default is c8).
# Ignore test coverage in both `git` and "prettier".
.PHONY: install
install:
	@node ./app.js $(name)
	@cd ../$(name)/ \
	&& pnpm update \
	&& pnpm add --save-dev vitest@latest \
	&& pnpm add --save-dev @vitest/coverage-c8 \
	&& echo '/coverage' >> .gitignore \
	&& echo '/coverage' >> .prettierignore

.PHONY: leadof-me
leadof-me:
	@"$(MAKE)" install name=$@

.PHONY: leadof-tech
leadof-tech:
	@"$(MAKE)" install name=$@

.PHONY: leadof-us
leadof-us:
	@"$(MAKE)" install name=$@

.PHONY: clean
clean:
	@cd ../ \
	&& rm --recursive --force \
		./leadof-me/ \
		./leadof-tech/ \
		./leadof-us/
