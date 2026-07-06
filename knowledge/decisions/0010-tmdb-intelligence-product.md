# ADR-0010: Extract on-device intelligence into a `TMDbIntelligence` product

- **Status:** Proposed
- **Date:** 2026-07-06
- **Deciders:** Adam Young

## Context

The package ships one main library product, `TMDb`, supporting all Apple
platforms plus Linux and Windows. Two Apple-only feature clusters live inside
it:

- **Natural-language search** — 26 files under
  `Sources/TMDb/Domain/Services/NaturalLanguageSearch/`.
- **Language-model tools** — 14 files under
  `Sources/TMDb/Domain/LanguageModelTools/`.

Their platform gating is deliberately minimal: only the framework adapters
(`PersonNameExtracting.swift`, `PromptLanguageDetecting.swift`) and the
`TMDbClient.naturalLanguageSearch` accessor are gated on
`#if canImport(NaturalLanguage)`, and the Foundation Models files on
`#if canImport(FoundationModels)`. The remaining ~23 files — including six
files of **public** types (`NaturalLanguageSearchService`, `SearchPlan`,
`NaturalLanguageSearchResult`, `NaturalLanguageSearchError`,
`NaturalLanguageSearchAvailability`, `SearchDegradation`) — are pure Swift and
compile everywhere.

**The problem (finding F9 of the 2026-06 external review):** on Linux and
Windows those public types compile and are constructible, but the only factory
(`TMDbClient.naturalLanguageSearch`, `TMDbClient.swift:317`) is gated away.
The cross-platform core carries an orphaned public surface — API that can
never function on two of the supported platforms.

The direct fix — gating the whole feature per-file behind
`#if canImport(NaturalLanguage)` — was assessed and rejected: swiftformat's
default `ifdef` indentation would reindent ~38 files (whole-file `#if` wraps),
plus ~13 test files and 4 `TMDbTesting` helpers, a churn-heavy diff that
leaves the monolith intact. The decision was deferred to this ADR.

**The enabling fact (verified 2026-07-06):** both feature clusters are built
entirely from **public** `TMDbClient` service accessors. The
`naturalLanguageSearch` factory composes its planner, executor, and data
source from `client.discover`, `client.search`, `client.genres`, etc.;
`TMDbToolbox.init(client:)` does the same for its eight tools. None of the 40
files references `APIClient`, `TMDbFactory`, or any other TMDb-internal
symbol. Extraction into a downstream module therefore requires **no** new
public surface on the core and no `@_spi`/`@testable` tricks.

## Decision

We will extract the two clusters into a new target and library product,
**`TMDbIntelligence`**, in the same package, depending on `TMDb`:

1. **Move all 40 source files** into `Sources/TMDbIntelligence/`, preserving
   the `NaturalLanguageSearch/` and `LanguageModelTools/` grouping. Types that
   are `internal` stay `internal` (module scope moves with them).
2. **Client accessors become extensions in the new module.** The gated
   `TMDbClient.naturalLanguageSearch` extension moves out of
   `TMDbClient.swift` into the new target verbatim;
   `TMDbClient+LanguageModelTools.swift` moves as-is. For consumers this is
   source-compatible modulo adding the product dependency and
   `import TMDbIntelligence`.
3. **Existing `#if canImport` gates move unchanged — no new per-file gating.**
   On Linux/Windows the module compiles but is inert (value types exist, no
   factory). The F9 objection is resolved at the *product* level: the core
   `TMDb` product no longer carries any Apple-only API, and importing
   `TMDbIntelligence` is an explicit opt-in to a module documented as
   Apple-platforms-only. The reindent problem disappears entirely.
4. **Mirror the testing kit:** a new `TMDbIntelligenceTesting` target and
   product takes the four NL helpers from `TMDbTesting`
   (`MockNaturalLanguageSearchService` and the three `+Sample` factories), so
   `TMDbTesting` keeps zero intelligence dependencies.
5. **New test targets** `TMDbIntelligenceTests` and
   `TMDbIntelligenceTestingTests` receive the moved unit tests;
   `TMDbIntegrationTests` stays a single target and gains a dependency on
   `TMDbIntelligence`.
6. **Release as 19.0.0** (source-breaking for feature users only).

## Consequences

- **The core becomes exactly cross-platform.** Every public symbol in the
  `TMDb` product now functions on every supported platform.
- **The boundary is physical.** A future dependency from core onto
  intelligence code will not compile — the compiler, not convention, enforces
  the layering.
- **Breaking change, narrow blast radius.** Only consumers of
  `naturalLanguageSearch`, `languageModelTools`, or `TMDbToolbox` change
  anything: add the `TMDbIntelligence` product (and, for its test doubles,
  `TMDbIntelligenceTesting`) plus an import. All other consumers upgrade
  cleanly.
- **CI must be swept, not just the build.** `ci.yml` (macOS **and** Linux
  jobs) and the `Makefile` hardcode the test filter
  `TMDbTests|TMDbTestingTests`; the new test targets must be added there and
  to `TMDb.xctestplan`, or their tests silently never run. `.codecov.yml`
  ignore paths for the three NL exclusions (and `Sources/TMDbTesting`) must
  track the moved paths. The hosted-docs workflow builds `--target TMDb` only
  and needs the combined-documentation setup.
- **Inert surface on Linux is accepted, relocated.** `TMDbIntelligence` on
  non-Apple platforms still exposes constructible value types with no
  factory. That is now a documented property of an explicitly platform-scoped
  opt-in module, not a wart on the core. If it ever proves confusing,
  alternative 4 below (empty module via a nested `.swiftformat`) remains
  available without another restructure.
- **More targets to maintain:** 4 library targets and 5 test targets, each
  with a DocC catalog to keep in sync.

## Alternatives considered

1. **Status quo** — keeps orphaned public API in the cross-platform core;
   the review finding stands unaddressed.
2. **Gate the whole feature per-file in place** (F9's original suggested
   fix) — ~55 files touched, swiftformat reindents every wrapped file, and
   the Apple-only code remains tangled through the core target.
3. **A separate package/repository** — real isolation, but couples releases
   across repos, splits the fixture corpus and CI, and violates
   promote-a-boundary-only-when-needed; a target boundary gives the same
   compiler enforcement at a fraction of the cost.
4. **Empty-module-on-Linux gating inside the new target** — wrap every file
   in `#if canImport(NaturalLanguage)` with a nested
   `Sources/TMDbIntelligence/.swiftformat` setting `--ifdef no-indent` to
   avoid the reindent. Viable follow-up if the inert surface causes support
   noise; not required to fix F9, and it would gate pure-Swift logic (and its
   Linux-runnable tests) out of Linux CI for no functional gain.
5. **Keep the NL testing helpers in `TMDbTesting`** (add a dependency on
   `TMDbIntelligence`) — fewer targets, but the cross-platform test kit would
   drag the intelligence module into every consumer's graph and muddy the
   per-product kit pattern established by ADR-0006.
