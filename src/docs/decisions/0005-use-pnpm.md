---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Use pnpm

## Context and Problem Statement

Cross-platform task automation will require the use of code packages.

## Decision Drivers

- Cross-platform
- Middleware consistency
- Task automation
- Code packages

## Considered Options

- Use [`pnpm`](https://pnpm.io/)
- Use `npm`
- Use [`yarn`](https://yarnpkg.com/)

## Decision Outcome

Chosen option: "Use pnpm", because of improved functionality over `npm`. The tool `yarn` made significant breakinging changes in the design of a recent major upgrade while still supporting backwards compatibility with previous versions. However, the use of the newer version of `yarn` creates some challenges with existing `npm` packages that make assumptions about the structure of the "node_modules" directories. The tool `pnpm` has many of the greatest features in `yarn`.

### Consequences

- Developers must install `pnpm`.
