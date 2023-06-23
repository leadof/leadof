ARG PUBLISHED_SOURCE_URL=https://github.com/leadof/leadof
ARG PUBLISHED_DOCUMENTATION_URL=https://github.com/leadof/leadof#readme

################################################################################
# Layer target: Smallest image
################################################################################
FROM docker.io/alpine:3.14 as smol

################################################################################
# Layer target: libraries
################################################################################
FROM ghcr.io/leadof/leadof/libraries:latest as libraries

################################################################################
# Layer target: node image
################################################################################
FROM ghcr.io/leadof/leadof/node:latest as node

################################################################################
# Layer target: project dependencies
################################################################################
FROM node as dependencies

RUN mkdir -p /usr/src/dependencies/

# application package (not the root)
COPY ./package.json /usr/src/dependencies/

WORKDIR /usr/src/dependencies/

RUN pnpm install \
  && rm -f ./package.json ./pnpm-lock.yaml

VOLUME [ "/usr/src/dependencies/" ]

################################################################################
# Layer target: contains project libraries
################################################################################
FROM node as node_libraries

RUN mkdir -p /usr/src/libraries/

# Expects: `--build-context libraries=container-image://localhost/leadof/libraries:latest`
COPY --from=libraries /usr/src/libraries/ /usr/src/libraries/

VOLUME [ "/usr/src/libraries/" ]

################################################################################
# Layer target: base for playwright browser automation
# All tags: https://mcr.microsoft.com/en-us/product/playwright/about
# IMPORTANT: version must match "@playwright/test" in "./package.json"
################################################################################
FROM ghcr.io/leadof/leadof/playwright:latest as playwright

################################################################################
# Layer target: playwright with dependencies
################################################################################
FROM playwright as playwright_dependencies

RUN mkdir -p /usr/src/dependencies/

COPY --from=dependencies /usr/src/dependencies/ /usr/src/dependencies/

COPY ./package.json /usr/src/dependencies/package.json

WORKDIR /usr/src/dependencies/

RUN pnpm install \
  && pnpm playwright install \
  && rm -f ./package.json ./pnpm-lock.yaml

VOLUME [ "/usr/src/dependencies/" ]

################################################################################
# Layer target: combined set of all dependencies for this application
################################################################################
FROM smol as all_dependencies

ARG PUBLISHED_SOURCE_URL
ARG PUBLISHED_DOCUMENTATION_URL

RUN mkdir -p /usr/src/libraries/ \
  && mkdir -p /usr/src/dependencies/web/ \
  && mkdir -p /usr/src/dependencies/playwright/

COPY --from=libraries /usr/src/libraries/ /usr/src/libraries/

COPY --from=dependencies /usr/src/dependencies/ /usr/src/dependencies/web/

COPY --from=playwright_dependencies /usr/src/dependencies/ /usr/src/dependencies/playwright/

VOLUME [ "/usr/src/libraries/", "/usr/src/dependencies/web/", "/usr/src/dependencies/playwright/" ]

LABEL org.opencontainers.image.documentation ${PUBLISHED_DOCUMENTATION_URL}
LABEL org.opencontainers.image.source ${PUBLISHED_SOURCE_URL}
LABEL org.opencontainers.image.description "The application script libraries."
