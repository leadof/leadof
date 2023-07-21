FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src

################################################################################
# Layer target: lint the application
################################################################################
FROM src as run_lint

WORKDIR /usr/src/leadof/src/apps/leadof-us/

RUN mkdir --parents ./test-results/lint/ \
  && pnpm local:lint 2>&1 | tee ./test-results/lint/lint-results.txt

WORKDIR /usr/src/leadof/src/apps/leadof-us/test-results/lint/

################################################################################
# Layer target: lint results
################################################################################
FROM smol

COPY --from=run_lint /usr/src/leadof/src/apps/leadof-us/test-results/lint/ /usr/src/lint/

VOLUME [ "/usr/src/lint/" ]
