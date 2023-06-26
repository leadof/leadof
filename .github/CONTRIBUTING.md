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
