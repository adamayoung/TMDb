# ADR-0002: Auto-pagination for Changes adapts `ChangedIDCollection`, excludes detail endpoints

- **Status:** Accepted
- **Date:** 2026-06-18
- **Deciders:** Adam Young

## Context

Auto-pagination (`all*` / `all*Pages` over `PagedAsyncSequence` /
`PagedPagesAsyncSequence`) was extended to the remaining paged services. Both
pagination primitives are driven by a page fetcher returning
`PageableListResult<Element>`, whose generic constraint requires
`Element: Codable & Identifiable & Equatable & Hashable & Sendable`.

`ChangesService` has eight `page:`-accepting methods, but in two shapes:

- The three **list** endpoints (`movieChanges` / `tvSeriesChanges` /
  `personChanges`) return `ChangedIDCollection` — which *does* carry
  `page` / `totalPages` / `totalResults`, but is a distinct type from
  `PageableListResult`, and its element `ChangedID` was not `Identifiable`.
- The five **detail** endpoints (`movieDetails` / `tvSeriesDetails` /
  `personDetails` / `tvSeasonDetails` / `tvEpisodeDetails`) return
  `ChangeCollection`, which is just `{ changes: [Change] }` — no page metadata,
  and `Change` is not `Identifiable`.

## Decision

We will add auto-pagination only to the three Changes **list** endpoints. Each
`all*` wrapper adapts the returned `ChangedIDCollection` into a
`PageableListResult<ChangedID>` via a private `init(changedIDCollection:)`, and
`ChangedID` gains an additive `Identifiable` conformance (it already exposes
`id: Int`). The five detail endpoints are **excluded**.

## Consequences

- The three change-list endpoints get the same lazy `AsyncSequence` ergonomics as
  every other paged endpoint, reusing the existing primitives unchanged.
- `ChangedID: Identifiable` is now public API; the only reason for the conformance
  is the pagination element constraint (`id` is the changed media identifier).
- The detail endpoints stay non-paginated. Honest "complete coverage" means *all
  paginable* endpoints — not literally every method that takes a `page:` argument.
- A small hand-written field mapping (`page`/`results`/`totalResults`/
  `totalPages`) now exists and must stay correct; a unit test asserts all four
  fields with distinct values to guard against a field swap.

## Alternatives considered

- **Make `ChangeCollection` paginate too** — rejected: it carries no page
  metadata, so the sequence could only terminate on an empty page, and `Change`
  isn't `Identifiable`. It is genuinely not a paginated resource.
- **A separate non-`PageableListResult` pagination primitive for `ChangedIDCollection`**
  — rejected as over-engineering; the adapter is a few lines and reuses the
  battle-tested primitives.
