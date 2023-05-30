---
status: accepted
date: 2023-05-29
deciders: ericis
---

# Use Ionic with Angular for web applications

## Context and Problem Statement

Building web applications involves a series of technology choices.

## Decision Drivers

-   Modern web
-   Mature
-   Rich ecosystem of community and knowledge
-   Fast, out-of-the-box developer experience
-   Developer tooling
-   Single Page Application
-   Pre-rendering support
-   Server-Side Rendering (SSR)
-   Progressive Web Application (PWA)
-   Tree shaking
-   Supports Web Components
-   "Easy" options for state management
-   First-class animation support
-   Rich ecosystem of components
-   Ability to use web codebase for Native Mobile Applications
-   Wide and mature support by "Big Tech" companies

## Considered Options

-   Use Ionic with Vue
-   Use Ionic with React
-   Use Ionic with Angular
-   Use Svelte with Ionic

## Decision Outcome

Chosen option: "Use Ionic with Angular". While good arguments can be made for all four of the considered options, Angular. React has had difficulty adopting Web Component support for several years and requires many more individual decisions than Angular (more decisions may be an advantage for some). Svelte and Vue have great features and an incredible community, but Svelte is still making significant architectural decisions while it matures and Vue does not have the same "Big Tech" support as either React (Facebook) or Angular (Google).

### Consequences

-   Inevitably, developers will disagree with some strong opinions
-   Developers must know and code in Ionic and Angular
