# ADR-0012: Enrich `TMDbError` with structured context

- **Status:** Accepted (targets 19.0.0)
- **Date:** 2026-07-24
- **Deciders:** Adam Young

## Context

The public `TMDbError` (thrown by every service via typed throws) carried only
an optional server message `String?` on its six HTTP-family cases. A consumer
debugging a production failure could not see the HTTP status code, TMDb's
documented numeric `status_code`, the endpoint that failed, or the `Retry-After`
delay on a 429. Internally the library already had all of this: the richer
`TMDbAPIError` distinguishes 13 HTTP statuses, the error body's `status_code`
was decoded (into `TMDbStatusResponse`) then discarded, and `HTTPResponse`
already parses `Retry-After`. The mapping seam (`ErrorMappingAPIClient`, see
[ADR-0001](0001-error-mapping-api-client.md)) collapsed that fidelity away at the
public boundary. Changing the associated values of a frozen-shaped public enum is
source-breaking, so this rides the 19.0.0 release train.

## Decision

We enrich `TMDbError` with structured context while keeping the case taxonomy
**semantic** (surface meaning, not transport codes):

- **`TMDbStatusCode`** — a public `RawRepresentable` **enum** over every code
  documented at developer.themoviedb.org/docs/errors, with an `.unknown(Int)`
  fallback that preserves the raw value. A single classifier `init?(rawValue:)`
  (never returns `nil`) is the only initializer; `.unknown` therefore only ever
  holds an **undocumented** code. Equality and hashing are by `rawValue`. The
  documented HTTP status for each code lives in its DocC comment, not in a
  second runtime table.
- **`TMDbErrorContext`** — a struct with `httpStatusCode`, `tmdbStatusCode`,
  `statusMessage`, `endpointPath`, and `retryAfter: Duration?` (all optional).
- **`TMDbError` case shape** — the six HTTP-family cases keep their semantic
  names but carry `TMDbErrorContext` instead of `String?`. Un-collapsing is done
  **through context, not new cases**: 5xx variants still map to `.serverError`
  and 405/406/422 to `.badRequest`, with the exact status in
  `context.httpStatusCode`. Two genuinely different failures get honest cases:
  `.invalidURL(String)` and `.encode(Error)` (previously `.badRequest` /
  `.unknown`).
- **Equatable** — two `TMDbError`s are equal when they are the same case with an
  equal `TMDbErrorContext`. The `Error`-carrying cases (`network`, `decode`,
  `encode`) remain by-case-only wildcards, since a Swift `Error` is not
  `Equatable` — this preserves the pre-existing behaviour for `network`/`decode`.
- **Redaction** — `endpointPath` is scrubbed of token-bearing segments
  (`/guest_session/{id}`, `/account/{id}`) before it leaves the library, so the
  context is safe to log.
- Mapping stays at the single `ErrorMappingAPIClient` choke point (ADR-0001);
  the context is assembled in `TMDbAPIClient.validate` and threaded across via
  `TMDbAPIError`.

## Consequences

- Consumers can branch on `context.httpStatusCode` / `context.tmdbStatusCode`
  and honour `context.retryAfter`, without the library exposing 13 HTTP-shaped
  public cases.
- Source-breaking: any `catch .notFound(let message)` becomes
  `catch .notFound(let context)` (message is `context.statusMessage`). Documented
  in `CHANGELOG.md` and `HandlingErrors.md`.
- One status-code table to maintain (`TMDbStatusCode`), tracking TMDb's docs.
  Adding a future documented code is source-breaking for exhaustive switches —
  accepted as rare, and already a major.
- The `endpointPath` redactor must be extended if TMDb adds another
  token-in-path endpoint shape.

## Alternatives considered

- **Promote the 13 HTTP-shaped internal cases to public** — rejected: a much
  larger, less semantic public surface and heavier churn, when the exact status
  fits cleanly in context ("semantic errors, not transport codes").
- **A struct-with-static-constants `TMDbStatusCode`** (open set, never
  source-breaks on additions) — rejected in favour of the switchable enum, which
  matches the well-regarded TMDbLib (.NET) model the feature is inspired by; the
  `.unknown(Int)` fallback covers new codes without a decode failure.
- **A runtime `httpStatusCode` property on `TMDbStatusCode`** — rejected as a
  redundant second mapping table; `TMDbErrorContext.httpStatusCode` is the
  authoritative runtime value, and the documented status is captured in DocC.
- **Purely additive change** — not possible on a frozen-shaped public enum whose
  associated values change.
