---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Check spelling with CSpell

## Context and Problem Statement

Spelling mistakes are as inevitable as bugs.

## Decision Drivers

-   Professional content

## Considered Options

-   VS Code editor-specific spelling check extensions
-   Use [CSpell](https://cspell.org/)

## Decision Outcome

Chosen option: "Use CSpell", to ensure that spelling checks are cross-platform and can be run on any machine; with or without VS Code.

### Consequences

-   Contributors must fix spelling errors and use the CSpell configuration to add known words or words to ignore.
