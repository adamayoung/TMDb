# ADR-0006: Ship a public `TMDbTesting` target (spy+stub mocks + real-data samples)

- **Status:** Accepted
- **Date:** 2026-06-23
- **Deciders:** Adam Young

## Context

Apps depending on `TMDb` had no supported way to test their own code against the
package. To fake a service they had to hand-roll a conformance to each of the 26
service protocols; the package's own `Tests/TMDbTests/Mocks` are
`@testable`-only and not shipped. Constructing return-type models for fixtures
was generally possible (almost every public model has a public memberwise init)
— with one exception, `GuestSession`, which was `Codable`-only.

## Decision

Ship a second **public library product, `TMDbTesting`**, that consumers add to
their test targets. It provides:

1. A `Mock<Name>Service` for all 26 service protocols — a spy (records each call
   with its arguments) plus a stub (`<key>Result: Result<…>` injected per
   method), mirroring the existing `MockAPIClient` idiom.
2. `.sample` / `.samples` real-data factories for **every** service return type,
   which double as the mocks' default return values so a freshly-constructed
   mock is usable with zero setup.

Supporting decisions:

- **Unstubbed methods return `.sample` (not fail-loud).** Unlike the internal
  `MockAPIClient`, which calls `preconditionFailure` when unstubbed, the public
  mocks return believable sample data by default. The audiences differ: a shipped
  testing library should be usable with zero setup, not crash a consumer's suite.
  Documented caveat: assert on stubbed values, not the defaults.
- **Thread-safe mocks.** Each mock is `@unchecked Sendable` with all mutable
  spy/stub state behind an `NSLock` (not `Mutex`/Synchronization, which needs
  iOS 18/macOS 15 — above the iOS 16/macOS 13 floor). Production fans service
  calls out concurrently (`async let`), so a mock shared across that must be
  race-free.
- **`GuestSession` gains a public memberwise init** — the one return-type model
  that lacked one. Purely additive (no manual `init(from:)`, so synthesised
  `Codable` is unaffected); mirrors `Session.init(success:sessionID:)`.
- **Nine video/image/watch-provider filter types gain `Sendable`.** They were the
  only filters lacking it (Search/Discover filters already had it) and could not
  otherwise be stored in a `Sendable` mock call-record. Additive, non-breaking,
  and arguably a latent fix (they are passed to `async` APIs).
- **`MockNaturalLanguageSearchService` is ungated.** The
  `NaturalLanguageSearchService` protocol and its types only `import Foundation`
  (no `#if canImport(NaturalLanguage)`); only the `TMDbClient.naturalLanguageSearch`
  *accessor* is gated. So the mock compiles and ships everywhere, giving
  Linux/Windows test targets parity.
- **DocC cross-module references use inline code spans**, not `` ``symbol`` ``
  links — cross-module symbol links fail to resolve under `make build-docs`
  (which documents all targets) and break CI.
- **`PageableListResult` / `TranslationCollection` samples** are defined as
  per-element **constrained extensions** (`where Result == MovieListItem`), not on
  the generic or the typealiases, avoiding the duplicate-specialisation ambiguity
  recorded in project memory.

## Consequences

- Consumers can fake any TMDb service and construct believable models in their
  own tests, with zero setup, against a stable public API.
- A new public surface to maintain: 26 mocks + samples for ~87 return types must
  track protocol and model changes. New service methods/return types need a
  matching mock method and sample.
- **Duplication with the internal `Tests/TMDbTests/Mocks/Models` factories**
  (~107 `+Mocks` files) is accepted for now: the public `.sample` set was seeded
  by copying their already-vetted real values, but the two corpora are not yet
  unified. Follow-up: converge the internal `+Mocks` onto `TMDbTesting`'s
  `.sample` (the test target already depends on `TMDbTesting`), removing the
  drift. Not done here to keep this change's scope bounded.
- The main-target footprint is small and additive (one model init + nine
  `Sendable` conformances); existing `import TMDb` builds are unchanged, and a new
  product does not enter a consumer's `Package.resolved` unless they depend on it.

## Alternatives considered

- **Relocate/ship the existing internal mocks** — rejected: they are model data
  factories (`.mock()`), not service-protocol mocks, and are `@testable`-coupled;
  exposing them would leak internal construction and still not provide service
  doubles.
- **A smaller hand-built sample set** — rejected: every mock method needs a
  default return, so samples must cover every return type regardless.
- **Drop `Sendable` from the affected mock call-records** instead of making the
  filters `Sendable` — rejected: it would make the call-record API inconsistent
  and leave a latent non-`Sendable` gap in the main API.
