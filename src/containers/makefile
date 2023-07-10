.DEFAULT_GOAL:=all

all: install

.PHONY: install
install:
	@cd ./libraries/ && "$(MAKE)" $@
	@cd ./nexus/ && "$(MAKE)" $@
	@cd ./node/ && "$(MAKE)" $@
	@cd ./node-chrome/ && "$(MAKE)" $@
	@cd ./playwright/ && "$(MAKE)" $@

.PHONY: clean
clean:
	@cd ./libraries/ && "$(MAKE)" $@
	@cd ./nexus/ && "$(MAKE)" $@
	@cd ./node/ && "$(MAKE)" $@
	@cd ./node-chrome/ && "$(MAKE)" $@
	@cd ./playwright/ && "$(MAKE)" $@

.PHONY: reset
reset:
	@cd ./libraries/ && "$(MAKE)" $@
	@cd ./nexus/ && "$(MAKE)" $@
	@cd ./node/ && "$(MAKE)" $@
	@cd ./node-chrome/ && "$(MAKE)" $@
	@cd ./playwright/ && "$(MAKE)" $@
