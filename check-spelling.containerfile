FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src

################################################################################
# Layer target: check spelling in the application
################################################################################
FROM src as run_spelling

RUN mkdir --parents /usr/src/leadof/test-results/spelling/ \
  && pnpm local:spelling 2>&1 | tee /usr/src/leadof/test-results/spelling/spelling-results.txt

WORKDIR /usr/src/leadof/test-results/spelling/

################################################################################
# Layer target: spelling results
################################################################################
FROM smol

COPY --from=run_spelling /usr/src/leadof/test-results/spelling/ /usr/src/spelling/

VOLUME [ "/usr/src/spelling/" ]
