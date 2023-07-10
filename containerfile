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

RUN mkdir --parents /usr/src/project/dependencies/

# application package (not the root)
COPY ./package.json ./pnpm-lock.yaml /usr/src/project/dependencies/

WORKDIR /usr/src/project/dependencies/

RUN pnpm --recursive install --frozen-lockfile \
  && rm -f ./package.json ./pnpm-lock.yaml

VOLUME [ "/usr/src/project/dependencies/" ]

################################################################################
# Layer target: contains project src
################################################################################
FROM node as src

RUN mkdir --parents /usr/src/libraries/ \
  && mkdir --parents /usr/src/project/node_modules/

COPY --from=libraries /usr/src/libraries/ /usr/src/libraries/

COPY --from=dependencies /usr/src/project/dependencies/node_modules/ /usr/src/project/node_modules/

COPY . /usr/src/project/

WORKDIR /usr/src/project/

# make all shell scripts executable
RUN chmod +x /usr/src/libraries/shell/executable \
  && . /usr/src/libraries/shell/executable

VOLUME [ "/usr/src/project/" ]

################################################################################
# Layer target: lint the application
################################################################################
FROM src as run_lint

RUN mkdir --parents /usr/src/test-results/ \
  && mkdir --parents ./test-results/lint/ \
  && pnpm lint 2>&1 | tee /usr/src/test-results/lint-results.txt

WORKDIR /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

################################################################################
# Layer target: lint results
################################################################################
FROM smol as lint

COPY --from=run_lint /usr/src/test-results/ /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

################################################################################
# Layer target: check spelling in the application
################################################################################
FROM src as run_spelling

RUN mkdir --parents /usr/src/test-results/ \
  && mkdir --parents ./test-results/spelling/ \
  && pnpm spellcheck 2>&1 | tee /usr/src/test-results/spelling-results.txt

WORKDIR /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

################################################################################
# Layer target: spelling results
################################################################################
FROM smol as spelling

COPY --from=run_spelling /usr/src/test-results/ /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]
