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

RUN mkdir -p /usr/src/build-results/ \
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
FROM node as web

ARG PUBLISHED_SOURCE_URL
ARG PUBLISHED_DOCUMENTATION_URL

ENV PORT=4000
ENV NODE_ENV=production

RUN apt-get update && apt-get install -y --no-install-recommends dumb-init

USER node

COPY --chown=node:node --from=build /usr/src/build-results/app/ /usr/src/app/dist/app/

WORKDIR /usr/src/app/

# Server assumes a working directory above "./dist/app/", so
# pwd is "/usr/src/app/" above "./dist/app/" (browser and server)
CMD ["dumb-init", "node", "/usr/src/app/dist/app/server/main.js"]

LABEL org.opencontainers.image.documentation ${PUBLISHED_DOCUMENTATION_URL}
LABEL org.opencontainers.image.source ${PUBLISHED_SOURCE_URL}
LABEL org.opencontainers.image.description "The leadof.us web application."
