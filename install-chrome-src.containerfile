################################################################################
# Node + Chrome + Source code
#
# IMPORTANT: this file skips a dependency on "src" and replicates the same
#            steps in order to improve parallel execution. This is a classic
#            case where the "DRY" principle doesn't outweigh the performance
#            benefits of copy-paste.
################################################################################

FROM localhost/leadof/dependencies as dependencies
FROM localhost/leadof/libraries as libraries
FROM localhost/leadof/node-chrome as node_chrome

FROM node_chrome

USER node

RUN mkdir --parents /usr/src/libraries/ \
  && mkdir --parents /usr/src/leadof/node_modules/

COPY --from=libraries --chown=node:node /usr/src/libraries/ /usr/src/libraries/

COPY --from=dependencies --chown=node:node --chmod=0755 /usr/src/dependencies/ /usr/src/leadof/

COPY --chown=node:node . /usr/src/leadof/

WORKDIR /usr/src/leadof/

# make all shell scripts executable
RUN chmod +x /usr/src/libraries/shell/executable \
  && . /usr/src/libraries/shell/executable
