FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src

################################################################################
# Layer target: check spelling in the application
################################################################################
FROM src as run_spelling

RUN . ./check-spelling.sh

WORKDIR /usr/src/leadof/test-results/spelling/

################################################################################
# Layer target: spelling results
################################################################################
FROM smol

COPY --from=run_spelling /usr/src/leadof/test-results/spelling/ /usr/src/spelling/

VOLUME [ "/usr/src/spelling/" ]
