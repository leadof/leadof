################################################################################
# Layer target: Smallest image
################################################################################
FROM docker.io/alpine:3.14 as smol

################################################################################
# Layer target: node image
################################################################################
FROM localhost/leadof/node:latest as node

################################################################################
# Layer target: project dependencies
################################################################################
FROM node as dependencies

RUN mkdir -p /tmp/dependencies/

# application package (not the root)
COPY ./package.json /tmp/dependencies/

WORKDIR /tmp/dependencies/

RUN pnpm install \
  && rm -f ./package.json ./pnpm-lock.yaml

VOLUME [ "/tmp/dependencies/" ]

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
FROM localhost/leadof/playwright:latest as playwright

################################################################################
# Layer target: playwright with dependencies
################################################################################
FROM playwright as playwright_dependencies

RUN mkdir -p /tmp/dependencies/

COPY --from=dependencies /tmp/dependencies/ /tmp/dependencies/

COPY ./package.json /tmp/dependencies/package.json

WORKDIR /tmp/dependencies/

RUN pnpm install \
  && pnpm playwright install \
  && rm -f ./package.json ./pnpm-lock.yaml

VOLUME [ "/tmp/dependencies/" ]

FROM smol as all_dependencies

RUN mkdir -p /usr/src/libraries/ \
  && mkdir -p /usr/src/dependencies/web/ \
  && mkdir -p /usr/src/dependencies/playwright/

# Expects: `--build-context libraries=container-image://localhost/leadof/libraries:latest`
COPY --from=libraries /usr/src/libraries/ /usr/src/libraries/

COPY --from=dependencies /tmp/dependencies/ /usr/src/dependencies/web/

COPY --from=playwright_dependencies /tmp/dependencies/ /usr/src/dependencies/playwright/

VOLUME [ "/usr/src/libraries/", "/usr/src/dependencies/web/", "/usr/src/dependencies/playwright/" ]
