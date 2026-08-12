# ADR-0018: Surface task cancellation as `TMDbError.cancelled`

- **Status:** Accepted (in 20.0.0, unreleased)
- **Date:** 2026-08-12
- **Deciders:** Adam Young

## Context

`TMDbAPIClient.perform` wrapped **every** transport error as
`TMDbAPIError.network(error)`, and cancellation arrives there in two shapes:

- `CancellationError`, from `Task.sleep` during `RetryHTTPClient` backoff.
- A URL-loading cancellation from the transport adapter — `URLError(.cancelled)`
  on Darwin, and on Linux an `NSError` in `NSURLErrorDomain` that does not
  necessarily bridge to `URLError`.

So a cancelled task surfaced as `TMDbError.network`: a SwiftUI `.task {}`
cancelled on view dismissal looked like an outage, `withThrowingTaskGroup`
sibling cancellation produced N phantom network errors, app-level "retry on
network error" logic re-ran work the user had cancelled, and telemetry counted
cancellations as outages. `catch is CancellationError` never matched, and the
wrapped inner error's type was timing-dependent, so even an unwrapping consumer
had to match both shapes.

The root cause is that typed `throws(TMDbError)` cannot carry a bare
`CancellationError`. [ADR-0013](0013-cached-image-url-resolver.md) noted this in
passing and used it to justify leaving `APIConfigurationStore`'s shared-fetch
joins uncancellable — so the gap had already propagated into a second design.

Issue #419. Adding a public enum case is source-breaking, so it had to ride the
open 20.0.0 window or wait a full major cycle.

## Decision

**Cancellation the library observes surfaces as `TMDbError.cancelled`** — a case
with **no associated value**. Unlike the six HTTP-family cases there is no server
context to carry: nothing failed, the caller withdrew.

**One classifier, `Error.isTaskCancellation`** (`Networking/Error+Cancellation.swift`),
so the two shapes cannot drift apart across mapping sites:

- `CancellationError` matches unconditionally — only the cancellation machinery
  raises it.
- A URL-loading cancellation matches **only when `Task.isCancelled`**.
  `URLSession.invalidateAndCancel()` and app teardown raise the same code while
  the calling task is alive; that is a real failure and must stay `.network`
  rather than be swallowed by a consumer's `catch TMDbError.cancelled`.
  Cancellation is sticky and monotone within a task, so the guard cannot
  under-match a genuine one.
- Matched on `NSURLErrorDomain` + `NSURLErrorCancelled` rather than
  `as? URLError`, because of the Linux bridge. This is deliberately **not**
  provable by the integration suite, which never runs on Linux in CI — a
  Linux-runnable unit test injecting that `NSError` is the real coverage.

**`RetryHTTPClient` keeps its own two checks unchanged.** They answer a different
question — *should this be retried?* — for which a session-initiated
cancellation is also "no", regardless of `Task.isCancelled`. Unifying all four
sites would have made a session-cancelled request retryable.

**Two carve-outs, documented rather than papered over.** The rule holds only for
cancellation the library actually *observes*:

- A caller served from `APIConfigurationStore`'s cache never suspends, so it
  returns its value.
- A **consumer-supplied** `PageFetcher` (`PagedAsyncSequence.init(pageFetcher:)`
  is public and untyped-throwing) keeps its own error type.

The auto-pagination check moved *above* the buffered fast path, so a cancelled
consumer stops at the next element instead of draining a full page.

**`TMDbIntelligence` gets its own case.** `NaturalLanguageSearchError.cancelled`,
because a cancelled plan was wrapped as `.planningFailed`, which `canFallBack`
treats as fallback-eligible — so the library issued three fresh live searches on
an already-cancelled task. That is the "retry the work the user cancelled" harm
in the library's own code, so the mapping alone was not enough: `canFallBack`
must also return `false`.

## Consequences

- Consumers write `catch TMDbError.cancelled`. `catch is CancellationError` does
  **not** match, and cannot under typed throws — called out in *Handling Errors*.
- Source-breaking twice: exhaustive switches over `TMDbError` **and**
  `NaturalLanguageSearchError` need a new arm. Both `==` operators carry
  `default: false`, so a missing arm compiles and is silently wrong — only a test
  catches it, hence explicit inequality assertions on both enums.
- Behaviour-breaking for paged scans (`CancellationError` → `.cancelled`) and for
  `client.images` (a waiting caller now throws where it previously returned).
- Incidental security improvement: the cancelled path no longer wraps the
  transport `NSError`, which on Apple platforms carries
  `NSURLErrorFailingURLErrorKey` — the full URL, including the `api_key` query
  item. The surviving `.network(_:)` path still does; tracked separately.

## Alternatives considered

- **Rethrow a bare `CancellationError`** — impossible without removing
  `throws(TMDbError)` from every service method.
- **`TMDbError.cancelled` carrying a `TMDbErrorContext`** — rejected: there is no
  server response to describe, and a context of all-`nil`s is worse than none.
- **Leave the paged sequences throwing `CancellationError`** (untyped `next()`,
  so no constraint forces the change) — rejected: cancelling a scan would still
  yield either shape depending on when it landed, which is the defect being
  fixed. The honest alternative, a typed `Failure == TMDbError` iterator, is
  compile-visible but a much larger change; deferred.
- **Drop `TMDbAPIError.cancelled` and classify in the mapper's `.network` arm** —
  rejected: keeping the internal taxonomy complete matches
  [ADR-0001](0001-error-mapping-api-client.md).
- **A waiter registry on `APIConfigurationStore`** instead of the per-call
  `ResumeOnce` box — rejected; see [ADR-0013](0013-cached-image-url-resolver.md)
  and `gotchas.md`.
