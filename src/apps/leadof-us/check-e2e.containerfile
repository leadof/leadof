################################################################################
# Layer target: Smallest image
################################################################################
FROM docker.io/redhat/ubi8-micro as smol

################################################################################
# Layer target: application dependencies
################################################################################
FROM localhost/leadof-us/dependencies:latest as dependencies

################################################################################
# Layer target: base for playwright browser automation
# All tags: https://mcr.microsoft.com/en-us/product/playwright/about
# IMPORTANT: version must match "@playwright/test" in "./package.json"
################################################################################
FROM ghcr.io/leadof/leadof/playwright:latest as playwright

################################################################################
# Layer target: source code for playwright tests
################################################################################
FROM playwright as playwright_src

RUN mkdir -p /usr/src/libraries/ \
  && mkdir -p /usr/src/apps/leadof-us/node_modules/

COPY --from=dependencies /usr/src/libraries/ /usr/src/libraries/

COPY --from=dependencies /usr/src/dependencies/playwright/node_modules/ /usr/src/apps/leadof-us/node_modules/

COPY . /usr/src/apps/leadof-us/

WORKDIR /usr/src/apps/leadof-us/

# make all shell scripts executable
RUN chmod +x /usr/src/libraries/shell/executable \
  && . /usr/src/libraries/shell/executable

VOLUME [ "/usr/src/apps/leadof-us/" ]

################################################################################
# Layer target: run end-to-end tests
################################################################################
FROM playwright_src as run_e2e

RUN mkdir -p /usr/src/test-results/ \
  && mkdir -p ./test-results/e2e/ \
  && pnpm playwright test \
  && mv ./test-results/e2e/lighthouse.html /usr/src/test-results/ \
  && mv ./test-results/e2e/playwright-reports/index.html /usr/src/test-results/playwright.html

WORKDIR /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]

################################################################################
# Layer target: end-to-end test results
################################################################################
FROM smol as e2e

COPY --from=run_e2e /usr/src/test-results/ /usr/src/test-results/

VOLUME [ "/usr/src/test-results/" ]
