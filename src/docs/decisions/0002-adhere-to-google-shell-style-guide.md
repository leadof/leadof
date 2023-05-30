---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Adhere to Google Shell Style Guide

## Context and Problem Statement

Developers carry different opinions about how to code and how to document that code. Common standards and conventions help establish a baseline of consistency across development for a project.

## Decision Drivers

-   Code consistency

## Considered Options

-   Allow complete freedom of choice
-   Create custom shell script standards
-   [Adopt the Google shell script guide](https://google.github.io/styleguide/shellguide.html)

## Decision Outcome

Chosen option: "Adopt the Google shell script guide", because it is an existing, well-documented and proven guide that strikes a balance of allowing certain freedoms while also establishing certain standards and conventions for development.

_\***Exception:** this project uses POSIX-compatible shell scripts rather than the Google standard for "bash" in order to support Linux Alpine distributions._

### Consequences

-   Developers must understand and follow the Google Shell Style Guide.
