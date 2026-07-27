# ADR-0013: Cache the image configuration in an actor behind `client.images`

- **Status:** Accepted (targets 19.x)
- **Date:** 2026-07-27
- **Deciders:** Adam Young

## Context

Turning `movie.posterPath` into a `URL` is the single most common thing consumers
of this package do, and it was a manual two-step: fetch `APIConfiguration` via
`client.configurations.apiConfiguration()`, hold on to its `ImagesConfiguration`,
then call the synchronous helpers in `ImagesConfiguration+URLs`. Nothing cached
that object at the client level, so every consumer invented its own lifecycle for
it. Competing clients (TMDbLib, tmdb-kotlin, brettohland/swift-tmdb) all resolve
an image URL in one call. Issue #391.

Constraints: Swift 6 strict concurrency; typed throws (`throws(TMDbError)`)
throughout; a macOS 13 / iOS 16 deployment floor, so `Synchronization.Mutex` is
unavailable and an `actor` is the only primitive that can hold state across an
`await`.

## Decision

We will add an `ImageService` protocol exposed as `TMDbClient.images`, backed by
an internal `APIConfigurationStore` actor that fetches `APIConfiguration` **at
most once per client** and shares that fetch with every concurrent caller.

**Why memoise at all.** Not primarily as a network win — that would be a weak
argument, since `/configuration` returns `Cache-Control: public, max-age` +
`ETag` and the default `URLCache` already caches the HTTP response on Apple
platforms (see *HTTP caching* in `tmdb-api-notes.md`, and
[ADR-0007](0007-document-existing-response-caching.md)). It earns its place
because it removes the config-lifecycle burden from the caller (the actual point
of #391), skips re-decoding `APIConfiguration` per image, does real caching work
on **Linux and Windows** where corelibs-foundation ships no `URLCache`, and is
**always on**, whereas `CacheHTTPClient` is opt-in and so cannot be relied on for
de-duplication.

**Publish the in-flight handle before the first suspension point.** A plain
`if let cached { … }; cached = try await fetch()` memo suspends *before* writing
anything, so N concurrent first-callers all miss and all fetch. Measured against
the naive version: **100 callers produced 100 fetches at peak concurrency 76.**
The store now stores the in-flight `Task` and publishes it synchronously on the
actor, so a later caller joins it.

**Carry the error as a value.** Typed throws cannot cross a `Task` — the stdlib
only vends initialisers constrained to `Failure == Never` and
`Failure == any Error`. We store `Task<Result<APIConfiguration, TMDbError>, Never>`
and unwrap with `Result.get()`, which is itself `throws(Failure)` in the Swift 6
stdlib, so `throws(TMDbError)` is preserved at the public boundary with no
untyped rethrow shim.

**Guard commits with a generation counter, and commit inside the task.** Without
this, a fetch superseded by `refresh()` would commit its stale value over the
newer one (leaving the cache **permanently stale**) and null out the live
in-flight handle (causing a redundant third fetch). The commit happens inside the
fetch task rather than in an awaiter's continuation: once the task resumes it is
back on the actor and runs the commit and its return with no suspension between,
giving the invariant *`inFlightFetch` is non-nil iff its task has not yet
committed* — which is what stops a late caller joining an already-finished fetch.

**`refresh()` detaches rather than cancels, keeps the cache until a replacement
lands, and coalesces.** Cancelling a superseded fetch would fail its other
awaiters because someone else refreshed. Clearing the cached value eagerly would
mean a refresh that then fails leaves the store cold, so a connectivity blip
during a pull-to-refresh would degrade every later image URL. And concurrent
refreshes join one fetch rather than each starting their own against a
rate-limited API.

**Cancellation is deliberately not forwarded.** This is the opposite call from
[ADR-0003](0003-opt-in-pagination-prefetch.md), and the difference is the awaiter
count: the prefetch iterator has exactly **one** owner-awaiter, so forwarding via
`withTaskCancellationHandler` is correct there. This fetch has **N** awaiters, so
forwarding would let any single cancelled caller fail all the others.

**Ten URL methods as protocol-extension methods over two requirements.** The
protocol requires only `imagesConfiguration()` and `refresh()`; `preload()` and
the ten `*URL(for:idealWidth:)` / `*URL(for:size:)` methods are extension methods
over them.

## Consequences

- The public API is **cancellation-unresponsive**: a cancelled caller waiting on
  the shared fetch is not interrupted and does not throw `CancellationError` — it
  waits for the fetch and receives its value. Bounded (one small request), and
  typed `throws(TMDbError)` could not honestly surface a `CancellationError`
  anyway. Documented on the protocol and in the How-To.
- `refresh()` may return a configuration fetched fractionally *before* the call,
  when it coalesces onto an in-flight refresh. Documented.
- Two ways now exist to build an image URL. The How-To leads with `client.images`
  and keeps the synchronous `ImagesConfiguration` helpers as the documented
  **batch** path, where an `await` per image would be wasteful.
- The extension-method shape avoids a real hazard: declaring the ten methods as
  requirements would need the same-signature default-witness idiom used by
  `AccountService+Defaults`, where a third-party conformer that skips a
  requirement compiles cleanly and then **infinitely recurses at runtime**. As
  extension methods that cannot arise. The cost is that they are statically
  dispatched and not individually stubbable — `MockImageService` stubs the two
  requirements, which transitively control every URL.
- **Watch:** the two families are unambiguous at the call site *only* because the
  `size:` family has no default argument. Adding `size: ImageSize = .original`
  would make `posterURL(for: x)` ambiguous at every call site.
- The store carries an internal `entryCount` used only by tests, because a caller
  that joins the shared fetch never reaches the mock and so cannot otherwise be
  observed (see *Testing a memoising actor* in `gotchas.md`).

## Alternatives considered

- **A nil-returning convenience** instead of `async throws(TMDbError)` — more
  convenient, but it hides a network fetch and an error surface behind something
  that looks total, and diverges from every other service. Rejected.
- **`actor TMDbImageService`** rather than a `final class` wrapping the actor.
  Compiles, but makes each of the ten synchronous `ImagesConfiguration` helpers a
  cross-actor hop, serialising pure string formatting even when the config is
  cached. Rejected.
- **A TTL on the cached value.** TMDb's image configuration changes roughly
  never; a TTL adds a clock, a config knob, and time-dependent tests for no real
  benefit. `refresh()` is the escape hatch instead.
- **Task identity instead of a generation counter** for the commit guard. `Task`
  is `Equatable`, but a task cannot reference itself from inside its own closure
  without a two-phase dance, and the commit lives inside the task. The counter is
  simpler and allocation-free.
- **Model-level async accessors** (`movie.posterURL(using: client.images, …)`)
  and a video-URL builder — both deferred to follow-ups to keep this change one
  coherent unit.
