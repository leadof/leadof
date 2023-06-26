.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@./install.sh

.PHONY: deploy
deploy: install
	@./deploy.sh

.PHONY: clean
clean:
	@rm -rf ./dist/ ./.wireit/*/cache ./node_modules/

.PHONY: reset
reset: clean
	@rm -rf ./.wireit/
