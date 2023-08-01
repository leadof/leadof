FROM localhost/leadof/node:latest as node
FROM localhost/leadof/smol:latest as smol

################################################################################
# Layer target: project dependencies
################################################################################
FROM node as dependencies

USER node

RUN mkdir --parents /usr/src/leadof/

WORKDIR /usr/src/leadof/

# Copy related pnpm files.
COPY --chown=node:node ./pnpm-lock.yaml ./pnpm-workspace.yaml /usr/src/leadof/

# Copy all package files.
COPY --chown=node:node ./.task-output/parse-dependencies.js/packages/ /usr/src/leadof/

# recursively install (all) dependencies
# cleanup source files and only store dependencies
#   cleanup ensures `COPY` won't override updated source files
RUN pnpm --recursive install --frozen-lockfile --reporter=append-only \
  && rm --force \
  ./pnpm-lock.yaml \
  ./pnpm-workspace.yaml \
  && find -type f -name 'package.json' -not -path "./node_modules/*" -delete

################################################################################
# Layer target: dependency results
################################################################################
FROM smol

COPY --from=dependencies /usr/src/leadof/ /usr/src/dependencies/

WORKDIR /usr/src/dependencies/

VOLUME [ "/usr/src/dependencies/" ]
