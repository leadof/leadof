---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Use Husky and git hooks

## Context and Problem Statement

Developers often forget to run thorough checks prior to committing and pushing their changes; including formatting and checking for spelling errors.

## Decision Drivers

-   Consistency
-   Early feedback and "shift-left"

## Considered Options

-   Rely on contributors to run all checks or to fix them after continuous integration has run
-   Use [Husky](https://typicode.github.io/husky/)

## Decision Outcome

Chosen option: "Use Husky", to ensure that formatting and spelling checks are always checked.

### Consequences

-   Contributors will install husky when other dependencies are installed and must fix issues prior to sharing them with others.
