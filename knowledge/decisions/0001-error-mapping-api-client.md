# ADR-0001: Centralise API error mapping in an ErrorMappingAPIClient decorator

- **Status:** Accepted (shipped in 18.0.0)
- **Date:** 2024 (retro-documented)
- **Deciders:** maintainer

> Retro-documented from the codebase to seed this log and establish the format.
> Rationale is reconstructed from `CLAUDE.md` and the networking layer; refine if
> the original intent differed.

## Context

Services call into an `APIClient` which builds requests, validates response
status, and decodes bodies, surfacing an internal `TMDbAPIError`. Public callers,
however, should only ever see the public `TMDbError`. Mapping `TMDbAPIError →
TMDbError` at each call site (or inside every service) would duplicate the mapping
logic across ~26 services and risk inconsistency.

## Decision

Introduce an **`ErrorMappingAPIClient` decorator** that wraps the `APIClient` and
centralises translation of `TMDbAPIError` into the public `TMDbError`. It sits at
the top of the client stack:

```text
Service → ErrorMappingAPIClient → TMDbAPIClient → HTTPClient → …
```

## Consequences

- **Single place** for error translation — services and call sites stay free of
  mapping logic, and the public error contract is consistent across all services.
- Adds one more decorator layer to understand in the networking stack (alongside
  the opt-in `CacheHTTPClient` / `RetryHTTPClient`).
- New public error cases are added in one location; reviewers should check error
  mapping there rather than per service.

## Alternatives considered

- **Map per service / per call site** — rejected: duplication across 26 services
  and drift risk.
- **Map inside `TMDbAPIClient`** — rejected: keeps a clean separation between
  "transport + decode" (`TMDbAPIClient`) and "public error contract"
  (`ErrorMappingAPIClient`), matching the existing decorator pattern.
