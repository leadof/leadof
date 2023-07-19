FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src

################################################################################
# Layer target: lint the application
################################################################################
FROM src as run_lint

WORKDIR /usr/src/apps/leadof-us/

RUN mkdir --parents ./test-results/lint/ \
  && pnpm lint 2>&1 | tee ./test-results/lint-results.txt

WORKDIR /usr/src/apps/leadof-us/test-results/lint/

VOLUME [ "/usr/src/apps/leadof-us/test-results/lint/" ]

################################################################################
# Layer target: lint results
################################################################################
FROM smol as lint

COPY --from=run_lint /usr/src/apps/leadof-us/test-results/lint/ /usr/src/apps/leadof-us/test-results/lint/

VOLUME [ "/usr/src/apps/leadof-us/test-results/lint/" ]
