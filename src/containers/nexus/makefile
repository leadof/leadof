.DEFAULT_GOAL:=all

all: install

.PHONY: install-java
install-java:
	@mvnw install

.PHONY: install
install:
	@./install.sh

.PHONY: start
start:
	@./start.sh

.PHONY: stop
stop:
	@./stop.sh

.PHONY: restart
restart: stop start

.PHONY: clean-java
clean-java:
	@mvnw clean

.PHONY: clean
clean: clean-java
	@./clean.sh

.PHONY: reset-java
reset-java:
	@rm --recursive --force ~/.m2/ ~/.groovy/grapes/ \
	&& mkdir ~/.m2/ \
	&& mkdir --parents ~/.groovy/grapes/

.PHONY: reset
reset: clean reset-java
	@podman rmi --force localhost/leadof/nexus:latest || true
	@podman volume rm --force nexus-data || true
