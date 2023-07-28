ARG NODE_VERSION="18.17.0"
ARG IMAGE_NODE_OS="bullseye-slim"
ARG IMAGE_NODE_TAG="docker.io/library/node:${NODE_VERSION}-${IMAGE_NODE_OS}"

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
# Layer target: build the application
################################################################################
FROM src as run_build

RUN mkdir --parents /usr/src/build-results/ \
  && pnpm build:ssr \
  && mv ./dist/* /usr/src/build-results/

VOLUME [ "/usr/src/build-results/" ]

################################################################################
# Layer target: build results
################################################################################
FROM smol as build

COPY --from=run_build /usr/src/build-results/ /usr/src/build-results/

WORKDIR /usr/src/build-results/

RUN ls -la

VOLUME [ "/usr/src/build-results/" ]

################################################################################
# Layer target: prepare a web production image
################################################################################
FROM ${IMAGE_NODE_TAG} as web

ARG PUBLISHED_SOURCE_URL
ARG PUBLISHED_DOCUMENTATION_URL

ENV PORT=4000
ENV NODE_ENV=production

# update package sources
# install dumb-init
# upgrade all packages (patch)
RUN apt-get update --quiet \
  && DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends dumb-init \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
  # clean up docker layer
  # https://docs.docker.com/develop/develop-images/dockerfile_best_practices/#run
  && rm --recursive --force /var/lib/apt/lists/*

USER node

COPY --chown=node:node --from=build /usr/src/build-results/app/ /usr/src/app/dist/app/

WORKDIR /usr/src/app/

# Server assumes a working directory above "./dist/app/", so
# pwd is "/usr/src/app/" above "./dist/app/" (browser and server)
CMD ["dumb-init", "node", "/usr/src/app/dist/app/server/main.js"]

LABEL org.opencontainers.image.documentation ${PUBLISHED_DOCUMENTATION_URL}
LABEL org.opencontainers.image.source ${PUBLISHED_SOURCE_URL}
LABEL org.opencontainers.image.description "The leadof.us web application."
