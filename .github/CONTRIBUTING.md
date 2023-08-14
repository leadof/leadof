# Contributing

This project is currently shared source, but not licensed for use by others or open to contribution at this time.

## Standards

-   Shell scripts generally adheres to the [Google "shellguide"](https://google.github.io/styleguide/shellguide.html), but use POSIX-compatible scripts and the `#!/bin/sh` executable rather than `#!/bin/bash`.
-   Decisions are documented as "Any Decision Records" using the ["Markdown Any Decision Records (MADR) format](https://adr.github.io/madr/).

## Used ports

-   **4000:** leadof.us SSR container host
-   **4200:** leadof.us
-   **4201:** leadof.us end-to-end tests

## Developer Setup

### Run the production website locally

`podman run --name leadof-us-dev --detach --publish 4000:4000 ghcr.io/leadof/leadof-us/web:latest`

### Development

1. Clone with the command `gh repo clone leadof/leadof`
2. Setup prerequisites as well as run all tests and builds with the command `make all` _\*please note that this command may change the version of NodeJS using `nvm`, may change the version of `npm` and will install a specific version of `pnpm`_

Each project has specific tasks defined in the relative "./makefile" and "./package.json" file.

GNU `make` is used to keep task commands simple while NodeJS and `pnpm` are used with "wireit" to define task dependencies and improve task execution performance with support for parallel task execution as well as caching for improved task repetition.

## Versions

Locally, versions of `node`, `npm` and `pnpm` will be checked with the command `make prerequisites` or `make pre`.

-   Node should use `nvm` and is specified in the root ".nvmrc" file. Search for the version number in other files.
-   The `npm` command version is specified in the root ".npm-version" file. Search for the version number in other files.
-   The `pnpm` command version is specified in the root ".pnpm-version" file. Search for the version number in other files.
-   Nexus version under "./src/containers/nexus/containerfile"
-   Groovy and JDK versions under "./src/containers/nexus/start.sh"
-   Playwright version under "./src/containers/playwright/containerfile". This version should match each application's version
-   Alpine version under "./src/containers/smol/containerfile"
-   Chrome version should be "latest" and should not require updating under "./src/containers/node-chrome/containerfile"
-   All NodeJS dependencies can be managed with `make update` at the root and `make update-latest` to bump version ranges

## Conventions

-   `clean` and `reset` commands always use shell script commands rather than NodeJS scripts. Since `pnpm` and "wireit" both rely on "node_modules" and ".wireit" directories, there could be issues with cleaning and removing those directories and files during execution.

## Troubleshooting

-   [Avoid the ":latest" tag on local containers](https://stackoverflow.com/a/64057789/6258497)
-   Known BUG 🐛: [Angular SSR outputs "selector error" warnings](https://github.com/ionic-team/ionic-cli/issues/4774)

## Tips

When debugging command output to NodeJS execution, check if the command outputs to "stdout" and/or "stderr"; some do one, both, or the other. Redirect "stderr" with `some_cmd 2>/dev/null`. Redirect "stdout" with `some_cmd >/dev/null`. And, redirect both with `some_cmd >/dev/null 2>&1`.

## Technical History notes

-   ["pretty-quick"](https://github.com/azz/pretty-quick/) was replaced with ["lint-staged"](https://github.com/okonet/lint-staged) because of a [dependency incompatibility](https://github.com/azz/pretty-quick/issues/164) introduced with "prettier@3.0.0" and a reliance on very limited code support
