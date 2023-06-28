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
