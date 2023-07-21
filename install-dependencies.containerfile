FROM localhost/leadof/node:latest as node

################################################################################
# Layer target: project dependencies
################################################################################
FROM node as dependencies

USER node

RUN mkdir --parents /usr/src/leadof/

WORKDIR /usr/src/leadof/

RUN mkdir --parents /usr/src/.containers/pnpm-store/

# CONTAINER packages
COPY --chown=node:node ./src/containers/libraries/package.json /usr/src/leadof/src/containers/libraries/
# COPY --chown=node:node ./src/containers/nexus/package.json /usr/src/leadof/src/containers/nexus/
COPY --chown=node:node ./src/containers/node/package.json /usr/src/leadof/src/containers/node/
COPY --chown=node:node ./src/containers/node-chrome/package.json /usr/src/leadof/src/containers/node-chrome/
COPY --chown=node:node ./src/containers/playwright/package.json /usr/src/leadof/src/containers/playwright/

# ROOT package
COPY --chown=node:node ./package.json ./pnpm-lock.yaml ./pnpm-workspace.yaml /usr/src/leadof/

# APPS packages
COPY --chown=node:node ./src/apps/leadof-us/package.json /usr/src/leadof/src/apps/leadof-us/

# CACHED dependencies
COPY --chown=node:node ./.containers/pnpm-store/ /usr/src/leadof/.containers/pnpm-store/

# set pnpm store location
# ensure the pnpm store directory exists
# install (all) dependencies
# cleanup source files and only store dependencies
#   *ensures `COPY` won't override updated source files
RUN pnpm config set store-dir /usr/src/leadof/.containers/pnpm-store/ \
  && mkdir --parents $(pnpm store path) \
  && pnpm --recursive install --frozen-lockfile --reporter=append-only \
  && rm --force \
  ./package.json \
  ./pnpm-lock.yaml \
  ./pnpm-workspace.yaml \
  ./src/apps/leadof-us/package.json \
  ./src/containers/libraries/package.json \
  ./src/containers/node/package.json \
  ./src/containers/node-chrome/package.json \
  ./src/containers/playwright/package.json