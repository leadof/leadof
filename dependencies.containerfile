################################################################################
# Layer target: project dependencies
################################################################################
FROM ghcr.io/leadof/leadof/node:latest as dependencies

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

RUN pnpm config set store-dir /usr/src/.containers/pnpm-store/ \
  && mkdir -p $(pnpm store path) \
  && pnpm install --frozen-lockfile

VOLUME [ "/usr/src/" ]
