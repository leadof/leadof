FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src
FROM localhost/leadof/node-chrome:latest as node_chrome

################################################################################
# Layer target: build the application
################################################################################
FROM node_chrome as run_unit_test

COPY --from=src --chown=node:node /usr/src/leadof/ /usr/src/leadof/

WORKDIR /usr/src/leadof/src/apps/leadof-us/

RUN . ./check-test.sh

WORKDIR /usr/src/leadof/src/apps/leadof-us/test-results/unit_test/

################################################################################
# Layer target: unit test results
################################################################################
FROM smol

COPY --from=run_unit_test /usr/src/leadof/src/apps/leadof-us/test-results/unit_test/ /usr/src/unit_test/

WORKDIR /usr/src/unit_test/

VOLUME [ "/usr/src/unit_test/" ]
