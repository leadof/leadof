FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src

################################################################################
# Layer target: lint the application
################################################################################
FROM src as run_lint

USER node

WORKDIR /usr/src/leadof/src/apps/leadof-us/

RUN . ./check-lint.sh

WORKDIR /usr/src/leadof/src/apps/leadof-us/test-results/lint/

################################################################################
# Layer target: lint results
################################################################################
FROM smol

COPY --from=run_lint /usr/src/leadof/src/apps/leadof-us/test-results/lint/ /usr/src/lint/

VOLUME [ "/usr/src/lint/" ]
