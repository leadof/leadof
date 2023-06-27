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
# Layer target: lint the application
################################################################################
FROM src as run_lint

RUN mkdir -p /usr/src/test-results/ \
  && mkdir -p ./test-results/lint/ \
  && pnpm lint 2>&1 | tee /usr/src/test-results/lint-results.txt

WORKDIR /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

################################################################################
# Layer target: lint results
################################################################################
FROM smol as lint

COPY --from=run_lint /usr/src/test-results/ /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

LABEL org.opencontainers.image.documentation ${PUBLISHED_DOCUMENTATION_URL}
LABEL org.opencontainers.image.source ${PUBLISHED_SOURCE_URL}
LABEL org.opencontainers.image.description "The application source code."
