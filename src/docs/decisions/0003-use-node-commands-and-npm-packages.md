---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Use node Commands and npm packages

## Context and Problem Statement

With the baseline decision to [use POSIX shell script automation](./0001-use-posix-shell-script-automation.md), cross-platform commands and task automation becomes the next challenge for cross-platform support.

## Decision Drivers

- Middleware consistency.

## Considered Options

- Use NodeJS
- Use other scripting or compiled programming languages and code package ecosystems.

## Decision Outcome

Chosen option: "Use NodeJS", because of the ubiquity of JavaScript as a language, developer familarity with JavaScript and NodeJS, the availability of NodeJS on machines, the relatively small installation footprint, the cross-platform package ecosystem, how active the community is, and the cross-platform support.

### Consequences

- Developers must install `node` and `npm`.
