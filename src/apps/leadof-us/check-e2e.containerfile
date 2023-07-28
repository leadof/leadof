FROM localhost/leadof/smol:latest as smol
FROM localhost/leadof/src:latest as src
FROM localhost/leadof/playwright:latest as playwright

################################################################################
# Layer target: run end-to-end tests
################################################################################
FROM playwright as run_e2e

COPY --from=src /usr/src/leadof/ /usr/src/leadof/

WORKDIR /usr/src/leadof/src/apps/leadof-us/

# create a separate layer for the playwright install
RUN pnpm playwright install

RUN . ./check-e2e.sh

WORKDIR /usr/src/leadof/src/apps/leadof-us/test-results/e2e/

################################################################################
# Layer target: end-to-end test results
################################################################################
FROM smol

COPY --from=run_e2e /usr/src/leadof/src/apps/leadof-us/test-results/e2e/ /usr/src/e2e/

WORKDIR /usr/src/e2e/

VOLUME [ "/usr/src/e2e/" ]
