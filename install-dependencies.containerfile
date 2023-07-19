FROM localhost/leadof/node:latest as node

################################################################################
# Layer target: project dependencies
################################################################################
FROM node as dependencies

WORKDIR /usr/src/

COPY ./package.json ./pnpm-lock.yaml ./pnpm-workspace.yaml /usr/src/

COPY ./src/containers/libraries/package.json /usr/src/containers/libraries/
# COPY ./src/containers/nexus/package.json /usr/src/containers/nexus/
COPY ./src/containers/node/package.json /usr/src/containers/node/
COPY ./src/containers/node-chrome/package.json /usr/src/containers/node-chrome/
COPY ./src/containers/playwright/package.json /usr/src/containers/playwright/

COPY ./src/apps/leadof-us/package.json /usr/src/apps/leadof-us/

RUN mkdir --parents /usr/src/.containers/pnpm-store/

COPY ./.containers/pnpm-store/ /usr/src/.containers/pnpm-store/

# set pnpm store location
# ensure the pnpm store directory exists
# install (all) dependencies
# cleanup source files and only store dependencies
#   *ensures `COPY` won't override updated source files
RUN pnpm config set store-dir /usr/src/.containers/pnpm-store/ \
  && mkdir -p $(pnpm store path) \
  && pnpm --recursive install --frozen-lockfile \
  && rm -f \
  /usr/src/package.json \
  /usr/src/pnpm-lock.yaml \
  /usr/src/pnpm-workspace.yaml \
  /usr/src/apps/leadof-us/package.json \
  /usr/src/containers/libraries/package.json \
  /usr/src/containers/node/package.json \
  /usr/src/containers/node-chrome/package.json \
  /usr/src/containers/playwright/package.json
