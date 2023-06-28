ARG PUBLISHED_SOURCE_URL=https://github.com/leadof/leadof
ARG PUBLISHED_DOCUMENTATION_URL=https://github.com/leadof/leadof#readme

################################################################################
# Layer target: Smallest image
################################################################################
FROM docker.io/redhat/ubi8-micro as smol

################################################################################
# Layer target: contains project src
################################################################################
FROM localhost/leadof-us/src:latest as src

################################################################################
# Layer target: node with chrome browser
################################################################################
FROM ghcr.io/leadof/leadof/node-chrome:latest as node_chrome

################################################################################
# Layer target: build the application
################################################################################
FROM node_chrome as run_unit_test

COPY --from=src /usr/src/ /usr/src/

WORKDIR /usr/src/apps/leadof-us/

RUN mkdir -p /usr/src/test-results/ \
  && mkdir -p ./test-results/unit_test/ \
  && pnpm test \
  && mv ./test-results/unit_test/* /usr/src/test-results/

WORKDIR /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

################################################################################
# Layer target: unit test results
################################################################################
FROM smol as unit_test

COPY --from=run_unit_test /usr/src/test-results/ /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

LABEL org.opencontainers.image.documentation ${PUBLISHED_DOCUMENTATION_URL}
LABEL org.opencontainers.image.source ${PUBLISHED_SOURCE_URL}
LABEL org.opencontainers.image.description "The application source code."
