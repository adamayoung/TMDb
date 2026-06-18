# ADR-0005: `AuthenticatedSession` via additive extension overloads

- **Status:** Accepted
- **Date:** 2026-06-18
- **Deciders:** Adam Young

## Context

`AccountService` threads two arguments — `accountID: Int` and `session: Session`
— through every account-scoped method: 16 core methods plus 16 auto-pagination
methods (`AccountService+Pagination.swift`), 32 in total. Callers must obtain the
account id (from `details(session:).id`) and carry both values everywhere, which
is verbose and easy to mismatch.

We wanted a single first-class "authenticated user" value to pass instead. The
constraint that shaped the design: `AccountService` is a **`public protocol`**
(external code can conform to it), the project builds with **`--Werror`**
(warnings are errors), and the package's own `+Pagination` / `+Defaults`
extensions call the existing methods internally.

## Decision

Add a public value type **`AuthenticatedSession`** (`accountID` + `session`;
`Equatable, Hashable, Sendable`) and **32 `authenticatedSession:` overloads** as
**protocol-extension defaults** that forward to the existing
`(accountID:session:)` methods, plus a convenience
`AccountService.authenticatedSession(for:)` that fetches `details(session:)` and
bundles the result.

The change is **purely additive and non-breaking**:

- The new overloads are **extension defaults, not protocol requirements**. Adding
  a requirement to a public protocol is source-breaking for every external
  conformer; an extension default is not.
- The existing `(accountID:session:)` methods are **left in place and not
  deprecated**.
- `AuthenticatedSession` is **not `Codable`** — no API endpoint produces it, and
  adding `Codable` speculatively would bake a permanent serialization contract
  for a credential (`session.sessionID`). Persistence, if needed, is the caller's
  secure-storage responsibility.
- All 32 methods are covered (not just the 16 obvious core methods), so the
  wrapper is usable end-to-end including auto-pagination.

## Consequences

- Consumers get a one-value API (`favouriteMovies(authenticatedSession:)`) while
  existing call sites keep working unchanged — ships as a **minor** release.
- Two parallel surfaces now exist per method. The DocC `AccountService.md` lists
  both, with the `authenticatedSession:` form documented as preferred.
- If the `(accountID:session:)` forms are ever to be retired, that is a **major**
  version's work (they are protocol requirements), and the internal `+Pagination`
  / `+Defaults` callers must migrate first (see Alternatives).

## Alternatives considered

- **New methods as protocol requirements** (so the new form is "canonical").
  Rejected: source-breaking for external conformers — the exact opposite of the
  goal.
- **Deprecate the old `(accountID:session:)` methods** ("deprecate-and-add").
  Rejected: on a public protocol the requirements can't be removed in a minor
  release regardless, and because the package's own extensions call them, a
  `@available(*, deprecated)` would emit warnings that fail the `--Werror` build
  until every internal caller migrated. On a public, internally-consumed
  protocol, "deprecate-and-add" realistically reduces to "add an extension and
  document the new form as preferred" — which is what we did.
- **Add `Codable` to `AuthenticatedSession`** for "remembered login". Rejected as
  YAGNI; revisit with a fixture-pinned format if a real need appears.

Relates to [ADR-0004](0004-service-parameter-name-convention.md) (the other
recent AccountService API-ergonomics decision).
