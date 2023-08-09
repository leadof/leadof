ARG NODE_VERSION="18.17.0"
ARG IMAGE_NODE_OS="bullseye-slim"
ARG IMAGE_NODE_TAG="docker.io/library/node:${NODE_VERSION}-${IMAGE_NODE_OS}"

ARG PUBLISHED_SOURCE_URL=https://github.com/leadof/leadof
ARG PUBLISHED_DOCUMENTATION_URL=https://github.com/leadof/leadof#readme

FROM localhost/leadof/src as src

################################################################################
# Layer target: lint the application
################################################################################
FROM src as run_build

USER node

WORKDIR /usr/src/leadof/src/apps/leadof-us/

RUN pnpm local:build

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

COPY --chown=node:node --from=run_build /usr/src/leadof/src/apps/leadof-us/.task-output/build/app/ /usr/src/app/

ENV APP_PATH="./"

WORKDIR /usr/src/app/

# Server assumes a working directory above "./dist/app/", so
# pwd is "/usr/src/app/" above "./dist/app/" (browser and server)
CMD ["dumb-init", "node", "/usr/src/app/server/main.js"]

LABEL org.opencontainers.image.documentation ${PUBLISHED_DOCUMENTATION_URL}
LABEL org.opencontainers.image.source ${PUBLISHED_SOURCE_URL}
LABEL org.opencontainers.image.description "The leadof.us web application."
