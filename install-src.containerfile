FROM localhost/leadof/dependencies:latest as dependencies
FROM localhost/leadof/libraries:latest as libraries
FROM localhost/leadof/node:latest as node

################################################################################
# Layer target: contains project src
################################################################################
FROM node as src

RUN mkdir --parents /usr/src/libraries/ \
  && mkdir --parents /usr/src/leadof/node_modules/

COPY --from=libraries /usr/src/libraries/ /usr/src/libraries/

COPY --from=dependencies /usr/src/ /usr/src/leadof/

COPY . /usr/src/leadof/

WORKDIR /usr/src/leadof/

# make all shell scripts executable
RUN chmod +x /usr/src/libraries/shell/executable \
  && . /usr/src/libraries/shell/executable
