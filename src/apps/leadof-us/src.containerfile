ARG PUBLISHED_SOURCE_URL=https://github.com/leadof/leadof
ARG PUBLISHED_DOCUMENTATION_URL=https://github.com/leadof/leadof#readme

################################################################################
# Layer target: Smallest image
################################################################################
FROM docker.io/redhat/ubi8-micro as smol

################################################################################
# Layer target: node image
################################################################################
FROM ghcr.io/leadof/leadof/node:latest as node

################################################################################
# Layer target: application dependencies
################################################################################
FROM localhost/leadof-us/dependencies:latest as dependencies

################################################################################
# Layer target: contains project src
################################################################################
FROM node as src

RUN mkdir -p /usr/src/libraries/ \
  && mkdir -p /usr/src/apps/leadof-us/node_modules/

COPY --from=dependencies /usr/src/libraries/ /usr/src/libraries/

COPY --from=dependencies /usr/src/dependencies/web/node_modules/ /usr/src/apps/leadof-us/node_modules/

COPY . /usr/src/apps/leadof-us/

WORKDIR /usr/src/apps/leadof-us/

# make all shell scripts executable
RUN chmod +x /usr/src/libraries/shell/executable \
  && . /usr/src/libraries/shell/executable

VOLUME [ "/usr/src/apps/leadof-us/" ]

LABEL org.opencontainers.image.documentation ${PUBLISHED_DOCUMENTATION_URL}
LABEL org.opencontainers.image.source ${PUBLISHED_SOURCE_URL}
LABEL org.opencontainers.image.description "The application source code."
