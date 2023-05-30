---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Format with prettier

## Context and Problem Statement

Much like the decision ["Adhere to Google Shell Style Guide"](./0002-adhere-to-google-shell-style-guide.md), developers carry different opinions about how to code and how to document that code. Common standards and conventions help establish a baseline of consistency across development for a project.

## Decision Drivers

-   Code consistency

## Considered Options

-   Allow complete freedom of choice
-   Create custom shell script standards
-   Implement [prettier](https://prettier.io/) tools

## Decision Outcome

Chosen option: "Implement prettier tools", because it is an existing, well-documented and proven set of tooling that strikes a balance of allowing certain freedoms while also establishing certain standards and conventions for development.

### Consequences

-   Developers must understand and follow the prettier rules.
