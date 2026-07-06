# Plan: Extract `TMDbIntelligence` target + product

Implements [ADR-0010](../knowledge/decisions/0010-tmdb-intelligence-product.md).
Read the ADR first — it holds the rationale and the alternatives already
rejected; this plan is the mechanics. Drafted 2026-07-06 against `main` at
`07439fe` (post-18.2.0).

## Goal

Move the two Apple-only feature clusters — natural-language search and the
FoundationModels language-model tools — out of the `TMDb` target into a new
`TMDbIntelligence` target/product (and their test doubles into
`TMDbIntelligenceTesting`), so the core `TMDb` product carries no public API
that cannot function on Linux/Windows (review finding F9). Behaviour-preserving
throughout: **no logic changes, no renames, no new features** — files move,
imports and wiring follow.

## Verified grounding (do not re-derive)

- Both `TMDbClient.naturalLanguageSearch` (`TMDbClient.swift:317–373`) and
  `TMDbToolbox.init(client:)` build everything from **public** `TMDbClient`
  service accessors. No file in either cluster references `APIClient`,
  `TMDbFactory`, or `APIRequest`. Extraction needs no core changes beyond
  deleting the moved extension from `TMDbClient.swift`.
- The only reference to any moved type outside the two directories is
  `TMDbClient.swift` itself.
- `#if canImport(NaturalLanguage)` appears in exactly 3 source files
  (`PersonNameExtracting.swift`, `PromptLanguageDetecting.swift`,
  `TMDbClient.swift`); `#if canImport(FoundationModels)` in 14. Everything
  else in the clusters is pure Swift and compiles on Linux. **Keep all gates
  exactly as they are** — per ADR-0010 no new gating is added.
- CI test filters are **hardcoded strings in three places** (step 6) — the
  classic failure mode of this change is tests that silently stop running.

## Non-goals

- No `TMDbIntelligence`-internal API redesign (e.g. making the planner
  protocol public) — move, don't improve.
- No empty-module-on-Linux gating (ADR-0010 alternative 4).
- No repo split, no new external dependencies.

## Steps

### 1. Package manifest

In `Package.swift`:

- Add target `TMDbIntelligence` (depends on `TMDb`) and target
  `TMDbIntelligenceTesting` (depends on `TMDbIntelligence`; add `TMDbTesting`
  only if the moved samples actually use its helpers — check imports when
  moving).
- Add products `.library(name: "TMDbIntelligence", …)` and
  `.library(name: "TMDbIntelligenceTesting", …)`.
- Add test targets `TMDbIntelligenceTests` (depends on `TMDbIntelligence`,
  `TMDb`) and `TMDbIntelligenceTestingTests` (depends on
  `TMDbIntelligenceTesting`, `TMDbIntelligence`, `TMDb` — **no `@testable`**,
  see step 5).
- Add `TMDbIntelligence` to `TMDbIntegrationTests`' dependencies.

### 2. Move library sources

`git mv` (preserves history through the rename detection):

- `Sources/TMDb/Domain/Services/NaturalLanguageSearch/` (26 files)
  → `Sources/TMDbIntelligence/NaturalLanguageSearch/`
- `Sources/TMDb/Domain/LanguageModelTools/` (14 files)
  → `Sources/TMDbIntelligence/LanguageModelTools/`

Then:

- Every moved file gains `import TMDb` (alongside its existing imports).
  Public models/services it references (`Genre`, `MovieListItem`,
  `DiscoverMovieFilter`, service protocols, …) come from there.
- Cut the `#if canImport(NaturalLanguage)` extension block from
  `TMDbClient.swift:317–373` **verbatim** into a new file
  `Sources/TMDbIntelligence/NaturalLanguageSearch/TMDbClient+NaturalLanguageSearch.swift`
  (with `import TMDb`, keeping the gate, the `@available` line, and the DocC
  comment). `TMDbClient+LanguageModelTools.swift` already moved with its
  directory — it needs only the added import.
- File header comments say `TMDb` (the project, not the target) — the
  swiftformat `--header` rule is target-agnostic, so expect **no** header
  churn. If the post-edit hooks reformat anything else, re-`Read` before
  dependent edits.

### 3. Move the testing kit

`git mv` from `Sources/TMDbTesting/` to `Sources/TMDbIntelligenceTesting/`:

- `Services/MockNaturalLanguageSearchService.swift`
- `Samples/NaturalLanguageSearchResult+Sample.swift`
- `Samples/NaturalLanguageSearchAvailability+Sample.swift`
- `Samples/SearchPlan+Sample.swift`

Each gains `import TMDbIntelligence` (they already `import TMDb`, non-
`@testable` — keep it that way). Prune the NL mentions from
`Sources/TMDbTesting/TMDbTesting.docc/TMDbTesting.md` and create a minimal
`Sources/TMDbIntelligenceTesting/TMDbIntelligenceTesting.docc/TMDbIntelligenceTesting.md`
modelled on it.

### 4. Move unit tests

`git mv` the whole directories into `Tests/TMDbIntelligenceTests/`:

- `Tests/TMDbTests/Domain/Services/NaturalLanguageSearch/` (~15 files incl.
  `Mocks/` and `Helpers/`)
- `Tests/TMDbTests/Domain/LanguageModelTools/` (~5 files)

In each moved file change `@testable import TMDb` to
`@testable import TMDbIntelligence`, and add a plain `import TMDb` where core
public types are used (most files — fixtures build `MovieListItem` etc.).
Files testing gated code keep their existing `#if canImport` gates unchanged.

### 5. Move the testing-kit tests

`git mv Tests/TMDbTestingTests/Services/MockNaturalLanguageSearchServiceTests.swift`
→ `Tests/TMDbIntelligenceTestingTests/Services/`. Imports become
`import TMDbIntelligenceTesting` + `import TMDbIntelligence` + `import TMDb` —
**public imports only, no `@testable`**: this target exists to prove the kit
works through the public API a real consumer sees (the ADR-0006 pattern).

Integration tests (`Tests/TMDbIntegrationTests/NaturalLanguageSearch*.swift`,
3 files) stay put; each adds `import TMDbIntelligence`.

### 6. The CI/tooling sweep — the silent-failure step, do not skim

The filter string `TMDbTests|TMDbTestingTests` becomes
`TMDbTests|TMDbTestingTests|TMDbIntelligenceTests|TMDbIntelligenceTestingTests`
in **all three** places:

1. `Makefile` — `TEST_TARGET` variable.
2. `.github/workflows/ci.yml` — the macOS `Test` step (`swift test --filter …`).
3. `.github/workflows/ci.yml` — the Linux `Test` step (same flag, second job).

After the PR's CI runs, **verify from the run logs that the new targets'
suites actually executed** — a green run proves nothing if the filter missed
them. Then:

- `TMDb.xctestplan` — add the two new unit-test targets (mirror the existing
  entries). `Integration.xctestplan` is unchanged.
- `.codecov.yml` — update the three moved ignore paths to
  `Sources/TMDbIntelligence/NaturalLanguageSearch/FoundationModelsSearchPlanGenerator.swift`,
  `…/GeneratedSearchPlan.swift`, `…/LiveNaturalLanguageSearchDataSource.swift`,
  and add `Sources/TMDbIntelligenceTesting` beside the existing
  `Sources/TMDbTesting` ignore (same rationale comment). Do this **in the
  same commit as the move** or codecov/patch will grade the uncovered moved
  lines against the 80% target.
- Coverage export in `ci.yml` reads the single `TMDbPackageTests.xctest`
  binary — all test targets land in it, so no change needed there.

### 7. Documentation

- New `Sources/TMDbIntelligence/TMDbIntelligence.docc/` catalog with a
  landing page (overview: what the product is, Apple-platforms-only, the
  opt-in import) and Topics sections for the NL search types and
  `TMDbToolbox`. Move into it from `Sources/TMDb/TMDb.docc/`:
  `Extensions/NaturalLanguageSearchService.md`, `Extensions/TMDbToolbox.md`,
  `HowTos/UsingLanguageModelTools.md`.
- Prune `TMDb.docc/TMDb.md`: the `<doc:/UsingLanguageModelTools>` line (61)
  and the NL/toolbox topic entries (lines 242–251).
- **Cross-module DocC links do not resolve** (known gotcha from the
  `TMDbTesting` build): inside `TMDbIntelligence.docc`, reference `TMDb`
  types (`TMDbClient`, `MovieListItem`, …) with inline code spans, never
  ` ``symbol`` ` links; reserve ` ``links`` ` for same-module symbols.
  `make build-docs` runs warnings-as-errors and will catch violations.
- `.github/workflows/documentation.yml` builds `--target TMDb` only. Switch
  the hosted build to combined documentation
  (`--enable-experimental-combined-documentation`, listing the doc-bearing
  targets; swift-docc-plugin ≥ 1.4 supports it — already pinned 1.4.6).
  **Fallback if that fights back:** keep hosting `--target TMDb` and note in
  its landing page that `TMDbIntelligence` docs build locally/in Xcode —
  don't let docs hosting block the extraction PR; file a follow-up instead.
- `README.md`: the features list (lines ~45–47), the services table
  (`naturalLanguageSearch`, `languageModelTools` rows — note the required
  import), and the installation section (show adding the `TMDbIntelligence`
  product). Add a short "Migrating to 19.0" note: add the product dependency
  - `import TMDbIntelligence` (and `TMDbIntelligenceTesting` for the mocks);
  no code changes otherwise.
- `CLAUDE.md`: Architecture section — the facade list and the
  `naturalLanguageSearch` paragraph move under a new `TMDbIntelligence`
  bullet; update the Language Model Tools section's path.
- Flip ADR-0010's status to **Accepted** in the delivery PR.

### 8. Verification gates (in order, after the moves compile)

1. `/build` then `/build-for-testing` — expect SourceKit "cannot find X"
   false positives on freshly-moved files; trust the build, not the editor.
2. `/test` — all suites green, **confirm the run's suite list includes
   `TMDbIntelligenceTests` and `TMDbIntelligenceTestingTests`**.
3. `make test-linux` — proves the inert-module story: everything still
   compiles on Linux and the pure-Swift NL tests still run there.
4. `make build-docs` — catches missing `///` on anything whose access level
   shifted, and any cross-module DocC link.
5. `/integration-test` — the three NL integration suites still pass.
6. `make ci` — mandatory pre-PR gate.

## Test-first framing (for `/implement-plan`)

This is a behaviour-preserving refactor, so the canon-tdd test list is
mostly *inherited*: the moved suites are the reproduction tests and must pass
unmodified (imports aside). Genuinely new items:

1. A `TMDbIntelligenceTestingTests` suite compiles with **public imports
   only** (compiler-enforced; the moved mock tests provide it).
2. `swift build` succeeds on Linux (`make test-linux`) with the new targets —
   the Linux-inertness claim, exercised.
3. A consumer-shaped smoke assertion that `TMDbClient().naturalLanguageSearch`
   and `TMDbToolbox(client:)` resolve via `import TMDbIntelligence` (the
   moved `TMDbClientNaturalLanguageSearchTests` /
   `TMDbClientLanguageModelToolsTests` already cover this once their imports
   are updated — verify, don't duplicate).

## Risks

| Risk | Mitigation |
| --- | --- |
| New test targets never run in CI (hardcoded filters) | Step 6; eyeball the CI logs for the new suite names on the PR |
| codecov/patch fails on moved lines | Ignore-path updates land in the same commit as the move; moved tests keep the lines covered |
| DocC cross-module links break `build-docs` | Code spans for `TMDb` types in the new catalog; gate 4 catches stragglers |
| Combined-docs flag misbehaves on CI | Explicit fallback in step 7 — hosting stays `--target TMDb`, follow-up issue |
| SourceKit false positives after mass `git mv` | Known gotcha; trust `make build` / `make build-tests` |
| Hidden internal dependency the greps missed | First `swift build` after step 2 surfaces it as a missing-symbol error; resolve by moving the symbol with the cluster, never by widening core API without discussion |

## Delivery notes

- Run as a full (not lite) `/deliver`: ~50 files move, ~15 edit, CI and docs
  infra change — worktree off `origin/main`, `/review-plan` first.
- Suggested checkpoints: (1) manifest + source moves building;
  (2) testing kit + tests moved, unit tests green; (3) CI/tooling sweep;
  (4) docs + README + CLAUDE.md.
- Release: tag **19.0.0** after merge (breaking for feature users only).
  Release notes: the migration note from step 7.
