.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@cd ./libraries/ && "$(MAKE)" $@
	@cd ./node/ && "$(MAKE)" $@
	@cd ./node-chrome/ && "$(MAKE)" $@
	@cd ./playwright/ && "$(MAKE)" $@
