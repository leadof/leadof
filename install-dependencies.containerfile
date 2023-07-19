FROM localhost/leadof/node:latest as node

################################################################################
# Layer target: project dependencies
################################################################################
FROM node as dependencies

WORKDIR /usr/src/

RUN mkdir --parents /usr/src/.containers/pnpm-store/

# CONTAINER packages
COPY ./src/containers/libraries/package.json /usr/src/containers/libraries/
# COPY ./src/containers/nexus/package.json /usr/src/containers/nexus/
COPY ./src/containers/node/package.json /usr/src/containers/node/
COPY ./src/containers/node-chrome/package.json /usr/src/containers/node-chrome/
COPY ./src/containers/playwright/package.json /usr/src/containers/playwright/

# ROOT package
COPY ./package.json ./pnpm-lock.yaml ./pnpm-workspace.yaml /usr/src/

# APPS packages
COPY ./src/apps/leadof-us/package.json /usr/src/apps/leadof-us/

# CACHED dependencies
COPY ./.containers/pnpm-store/ /usr/src/.containers/pnpm-store/

# set pnpm store location
# ensure the pnpm store directory exists
# install (all) dependencies
# cleanup source files and only store dependencies
#   *ensures `COPY` won't override updated source files
RUN pnpm config set store-dir ./.containers/pnpm-store/ \
  && mkdir -p $(pnpm store path) \
  && pnpm --recursive install --frozen-lockfile \
  && rm -f \
  ./package.json \
  ./pnpm-lock.yaml \
  ./pnpm-workspace.yaml \
  ./apps/leadof-us/package.json \
  ./containers/libraries/package.json \
  ./containers/node/package.json \
  ./containers/node-chrome/package.json \
  ./containers/playwright/package.json
