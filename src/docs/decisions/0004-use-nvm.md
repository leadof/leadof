---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Use Node Version Manager

## Context and Problem Statement

Developers may have any NodeJS version installed or none. This project requires the developer to use [Node Version Manager (`nvm`)](https://github.com/nvm-sh/nvm) with special notes for Windows.

## Decision Drivers

- Middleware consistency.

## Considered Options

- Support multiple versions of NodeJS
- Require nvm

## Decision Outcome

Chosen option: "Require nvm", because of increased consistency across developer machines. Improvement in Developer Experience for consistency outweighed the Developer Experience of version choice. Developers can still quickly change versions for other projects.

### Consequences

- Developers must install `nvm`.
