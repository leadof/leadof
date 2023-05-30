---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Use POSIX Shell Script Automation

## Context and Problem Statement

Supporting cross-platform involves basic software pre-requisite decisions. Using POSIX shell scripts ensures a basic level of support for all systems including Alpine.

## Decision Drivers

-   Cross-platform automation
-   macOS
-   Windows
-   Linux including Alpine

## Considered Options

-   Use POSIX scripts
-   Use Bash scripts
-   Use Node scripts
-   Use other scripting languages
-   Use compiled languages

## Decision Outcome

Chosen option: "Use POSIX scripts", because of native support across nearly all platforms execpt Windows. However, modern Windows users may install tools like Git BASH or Windows Subsystem for Linux to execute the same scripts.

### Consequences

-   Developers must be able to execute POSIX shell scripts.
