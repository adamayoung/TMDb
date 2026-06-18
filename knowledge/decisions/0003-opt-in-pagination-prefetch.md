# ADR-0003: Opt-in next-page prefetch holds an unstructured Task on a value-type iterator

- **Status:** Accepted
- **Date:** 2026-06-18
- **Deciders:** Adam Young

## Context

The auto-pagination sequences (`PagedAsyncSequence`, `PagedPagesAsyncSequence`)
are strictly lazy: page N+1 is fetched only after the current page's buffer is
drained, so a long scan pays full inter-page network latency. We wanted an
opt-in lookahead that fetches the next page concurrently while the current one is
consumed, without changing the default behaviour or the 94 `all*`/`all*Pages`
signatures, and while staying portable (Linux/Windows) and clean under Swift 6
strict concurrency. The package had **no** `Task`/`TaskGroup`/`AsyncStream` in
`Sources/` before this — prefetch is its first hand-rolled `Task` lifecycle.

## Decision

Add a fluent `prefetchingNextPage() -> Self` modifier (internal `prefetchEnabled`
flag) to both sequences. The in-flight fetch is held in a plain
`var prefetchTask: Task<PageableListResult<Element>, Error>?` on the **value-type
`struct` iterator** — no lock, no actor, no `OSAllocatedUnfairLock`. The iterator
is non-`Sendable` and consumed by a single serial `next()` (the standard
`AsyncIteratorProtocol` contract), so the only shared state is the `Sendable`
`Task` handle; there is nothing to synchronise. Consumer cancellation is forwarded
into the unstructured prefetch `Task` via
`withTaskCancellationHandler { try await task.value } onCancel: { task.cancel() }`.
A shared `PrefetchPolicy.shouldPrefetchNext(currentPage:totalPages:)` keeps the
termination rule in one place. The default (un-prefetched) sequence is unchanged.

## Consequences

- Lower latency on long scans, opt-in per call site; emitted items/pages are
  identical to the serial sequence.
- **≤1 overshoot, accepted and documented:** on an early `break` at most one
  in-flight prefetch may run to completion — a value-type iterator has no `deinit`
  to cancel it on drop. For an unknown total (`totalPages == 0`) the terminating
  empty page a prefetch may fetch is the same page a serial scan fetches, so it
  never over-fetches a *known* end.
- **Single-consumer only** (the `AsyncIteratorProtocol` contract) — a copied
  iterator sharing the `Task` is unsupported; documented on the public modifier.
- Testing the cancellation forward needs care — see the gotcha
  *"Deterministically testing that cancellation is forwarded into an unstructured
  Task"* in [`gotchas.md`](../gotchas.md). Verified clean under Thread Sanitizer.

## Alternatives considered

- **A lock/actor around the iterator state** — rejected as speculative: the
  single-consumer, non-`Sendable`, serial-`next()` invariant means no concurrent
  access to guard. `OSAllocatedUnfairLock` was specifically rejected as Apple-only
  (breaks Linux/Windows); `NSLock` (the `DataTaskBox` precedent in
  `URLSessionHTTPClientAdapter`) would be the portable fallback if one were ever
  needed.
- **A reference-type holder with `deinit { task.cancel() }`** to cancel on early
  break — rejected: reintroduces `deinit`-timing uncertainty for little gain over
  the documented ≤1 overshoot.
- **Prefetch on by default** — rejected: it trades a possibly-wasted request for
  latency, which not every caller wants; opt-in keeps the lazy default intact.
- **Refactor the two iterators onto a shared core** — rejected: they back 94
  shipped methods; duplicating a ~15-line hook is lower-risk than restructuring
  load-bearing primitives. Only the `PrefetchPolicy` predicate is shared.
