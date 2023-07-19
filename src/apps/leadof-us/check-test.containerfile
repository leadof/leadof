FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src
FROM localhost/leadof/node-chrome:latest as node_chrome

################################################################################
# Layer target: build the application
################################################################################
FROM node_chrome as run_unit_test

COPY --from=src /usr/src/leadof/ /usr/src/

WORKDIR /usr/src/apps/leadof-us/

RUN mkdir --parents ./test-results/unit_test/ \
  && pnpm test

WORKDIR /usr/src/apps/leadof-us/test-results/unit_test/

VOLUME [ "/usr/src/apps/leadof-us/test-results/unit_test/" ]

################################################################################
# Layer target: unit test results
################################################################################
FROM smol as unit_test

COPY --from=run_unit_test /usr/src/apps/leadof-us/test-results/unit_test/ /usr/src/apps/leadof-us/test-results/unit_test/

VOLUME [ "/usr/src/apps/leadof-us/test-results/unit_test/" ]
