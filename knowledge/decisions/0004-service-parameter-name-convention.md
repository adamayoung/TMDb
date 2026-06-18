# ADR-0004: Service method parameter-name convention (`<entity>ID`)

- **Status:** Accepted
- **Date:** 2026-06-18
- **Deciders:** Adam Young

## Context

Service protocols expose many entity-keyed methods (`details`, `credits`,
`images`, …). The **external** argument label was already consistent everywhere
(`forMovie:`, `forTVSeries:`, `forPerson:`, …), but the **internal** parameter
name diverged: most methods used a domain-specific name (`movieID`, `tvSeriesID`,
`personID`, `collectionID`, `keywordID`) while a handful of `details(...)`
overloads used the generic `id`. The internal name is what Xcode shows as the
autocomplete placeholder and what appears in the documented signature, so the
inconsistency was a (minor) developer-experience wart.

Across the service layer the split was lopsided: ~24 methods used `<entity>ID`
and only 7 (`details(...)` outliers across 5 services) used `id`.

Renaming an internal parameter name is **source- and ABI-compatible** (only the
external label is part of the API contract — see
[gotchas.md → Public API](../gotchas.md)), so neither direction required a major
version bump or deprecation shims.

## Decision

We standardise on the domain-specific **`<entity>ID`** convention
(`movieID` / `tvSeriesID` / `personID` / `collectionID` / `keywordID`) for the
primary entity-ID parameter on service methods. The 7 `details(...)` outliers
were renamed to match their siblings.

`ChangesService` is intentionally **out of scope**: it uses `id` for the
movie/TV/person change feeds alongside `seasonID` / `episodeID`, a separate,
internally consistent surface. The internal `NaturalLanguageSearchDataSource`
protocol (which uses `id`) is likewise not part of the public service convention.

## Consequences

- The public service surface presents a single, predictable parameter-name style
  in autocomplete and generated docs.
- New service methods should follow `<entity>ID`; a future reviewer can treat a
  bare `id` on an entity-keyed service method as a lint-by-eye inconsistency.
- Because the change is non-breaking, it shipped as a normal (non-major) release.

## Alternatives considered

- **Standardise on generic `id`** (the original code-review suggestion, argued as
  "more fluent" since `forMovie:` already disambiguates). Rejected: it fights the
  dominant existing style and would have renamed ~24 methods instead of 7, for a
  larger diff and more churn with no compatibility benefit.
